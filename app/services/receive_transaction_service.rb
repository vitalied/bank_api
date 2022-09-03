class ReceiveTransactionService < ApplicationService
  def initialize(args = {})
    super()

    args.each { |name, value| instance_variable_set("@#{name}", value) }
  end

  def call
    %i[sender_iban receiver_iban amount].each do |field|
      raise TransactionError, "Missing :#{field}" if instance_variable_get("@#{field}").blank?
    end

    raise TransactionError, 'Receiving amount is less or equal to zero' if @amount.to_f <= 0

    sender_account = Account.find_by(iban: @sender_iban)
    raise TransactionError, "Can't find sender account iban=#{@sender_iban}" if sender_account.blank?

    receiver_account = Account.find_by(iban: @receiver_iban)
    raise TransactionError, "Can't find receiver account iban=#{@receiver_iban}" if receiver_account.blank?

    new_amount = receiver_account.amount + @amount.to_f

    ActiveRecord::Base.transaction do
      receiver_account.update!(amount: new_amount)

      Transaction.create!(
        account_id: receiver_account.id,
        transaction_type: Transaction::TRANSACTION_TYPE.receive,
        sender_iban: sender_account.iban,
        receiver_iban: receiver_account.iban,
        amount: @amount,
        notes: @notes
      )
    end
  end
end
