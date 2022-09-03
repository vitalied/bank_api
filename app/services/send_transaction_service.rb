class SendTransactionService < ApplicationService
  def initialize(args = {})
    super()

    args.each { |name, value| instance_variable_set("@#{name}", value) }
  end

  def call
    %i[account_id receiver_iban amount].each do |field|
      raise TransactionError, "Missing :#{field}" if instance_variable_get("@#{field}").blank?
    end

    raise TransactionError, 'Sending amount is less or equal to zero' if @amount.to_f <= 0

    sender_account = Account.find_by(id: @account_id)
    raise TransactionError, "Can't find sender account id=#{@account_id}" if sender_account.blank?

    if @amount.to_f > sender_account.amount.to_f
      raise TransactionError, 'Sender account amount is less then sending amount'
    end

    receiver_account = Account.find_by(iban: @receiver_iban)
    raise TransactionError, "Can't find receiver account iban=#{@receiver_iban}" if receiver_account.blank?

    new_amount = sender_account.amount - @amount.to_f

    ActiveRecord::Base.transaction do
      sender_account.update!(amount: new_amount)

      Transaction.create!(
        account_id: sender_account.id,
        transaction_type: Transaction::TRANSACTION_TYPE.send,
        sender_iban: sender_account.iban,
        receiver_iban: receiver_account.iban,
        amount: @amount,
        notes: @notes
      )
    end
  end
end
