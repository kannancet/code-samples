module MrabaETL
  class ActionDispatcherService

    attr_accessor :mraba_record
    DISPATCHER_MAP = {
      account_transfer?: MrabaETL::Actions::AddAccountTransferService,
      bank_transfer?: MrabaETL::Actions::AddBankTransferService,
      lastschrift?: MrabaETL::Actions::AddDTARowService
    }
    ACTION_MATCHED = true.freeze

    def initialize mraba_record:
      @mraba_record = mraba_record
    end

    def call
      action_map_selected = DISPATCHER_MAP.select { |action, klass| mraba_record.send(action.to_sym) == ACTION_MATCHED }
      action_service_klass = action_map_selected.values.first

      action_service_klass.new(mraba_record: mraba_record).call if action_service_klass
    end

  end
end
