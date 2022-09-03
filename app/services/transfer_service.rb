class TransferService < ApplicationService
  attr_reader :errors

  def initialize(args = {})
    super()

    args.each { |name, value| instance_variable_set("@#{name}", value) }
    @errors = []
  end

  def call
    %i[account_id sender_iban receiver_iban amount].each do |field|
      @errors << "Missing :#{field}" if instance_variable_get("@#{field}").blank?
    end
    return if @errors.present?

    ActiveRecord::Base.transaction do
      SendTransactionService.call(
        account_id: @account_id,
        receiver_iban: @receiver_iban,
        amount: @amount,
        notes: @notes
      )

      ReceiveTransactionService.call(
        sender_iban: @sender_iban,
        receiver_iban: @receiver_iban,
        amount: @amount,
        notes: @notes
      )
    rescue => e
      @errors << e.message
      raise ActiveRecord::Rollback
    end

    @errors.blank?
  end
end
