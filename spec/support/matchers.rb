# ///////////////////////////////SMS////////////////////////////////////////////////

RSpec::Matchers.define :inspect_BulkMessageResponse do |expected|
  status = []
  match do |actual|
    obj = actual.collect { |item| 
      expect(item).to have_attributes(:status => a_value, :cost => a_value, :number => a_value, :status => a_value )

    }
    obj.all? {|e| e.eql? true}
    # binding.pry
    # status.find { |st| st. == expected.expecteds[0][:status] }
    # binding.pry
  end

  failure_message_when_negated do |actual|
    "something went wrong. bulk sms response test failing"
  end
end


RSpec::Matchers.define :inspect_PremiumMessageResponse do |expected|
  status = []
  match do |actual|
    # binding.pry
    obj = actual.recipients.collect { |item| 
      expect(item).to have_attributes(:status => a_value, :messageId => a_value, :number => a_value, :status => a_value )
    }
    (obj.all? {|e| e.eql? true} && !actual.overview.nil?)
  end
  failure_message_when_negated do |actual|
    "something went wrong. premium sms response test failing"
  end
end

RSpec::Matchers.define :inspect_FetchMessageResponse do |expected|
  status = []
  match do |actual|
    # binding.pry
    obj = actual.responses.collect { |item| 
      expect(item).to have_attributes(:status => a_value, :messageId => a_value, :number => a_value, :status => a_value )
    }
    obj.all? {|e| e.eql? true}
  end
  failure_message_when_negated do |actual|
    "something went wrong. fetch sms response test failing"
  end
end


RSpec::Matchers.define :inspect_FetchSubscriptionResponse do |expected|
  status = []
  match do |actual|
    # binding.pry
    obj = actual.collect { |item| 
      expect(item).to have_attributes(:phoneNumber => a_value, :id => a_value, :date => a_value)
    }
    obj.all? {|e| e.eql? true}
  end
  failure_message_when_negated do |actual|
    "something went wrong. fetch sms response test failing"
  end
end


# /////////////////////////////PAYMENTS/////////////////////////////////////////////

RSpec::Matchers.define :inspect_MobileB2CResponse do |expected|
  status = []
  match do |actual|
    # binding.pry
    obj = actual.collect { |item| 
      expect(item).to have_attributes(:provider => a_value, :phoneNumber => a_value, :providerChannel => a_value, :transactionFee => a_value, :status => a_value, :value => a_value, :transactionId => a_value)
    }
    obj.all? {|e| e.eql? true}
  end
  failure_message_when_negated do |actual|
    "something went wrong. initiate mobile B2C response test failing"
  end
end


RSpec::Matchers.define :inspect_BankTransferResponse do |expected|
  status = []
  match do |actual|
    # binding.pry
    obj = actual.entries.collect { |item| 
      expect(item).to have_attributes(:accountNumber => a_value, :status => a_value, :transactionId => a_value, :transactionFee => a_value, :errorMessage => a_value)
    }
    # binding.pry
    (obj.all? {|e| e.eql? true} && actual.errorMessage.nil?)
   
  end
  failure_message_when_negated do |actual|
    "something went wrong. bank transfer response test failing"
  end
end

# ///////////////////////// AIRTIME ////////////////////////////////////

RSpec::Matchers.define :inspect_SendAirtimeResult do |expected|
  status = []
  match do |actual|
    # binding.pry
    # binding.pry
    # (:errorMessage => a_value, :numSent => a_value, :totalAmount => a_value, :totalDiscount => a_value, :responses => a_value)
    if !actual.responses.nil?
      obj = actual.responses.collect { |item| 
        expect(item).to have_attributes(:amount => a_value, :phoneNumber => a_value, :requestId => a_value, :status => a_value, :errorMessage => a_value, :discount => a_value)
      }
      (obj.all? {|e| e.eql? true} && !actual.totalAmount.nil? && !actual.totalDiscount.nil? && !actual.numSent.nil? && (actual.errorMessage.eql?("None") || actual.errorMessage.nil?) )
    else
      # binding.pry
      !actual.totalAmount.nil? && !actual.totalDiscount.nil? && !actual.numSent.nil? && (actual.errorMessage.eql?("None") || actual.errorMessage.nil?)
    end
  end
  failure_message_when_negated do |actual|
    "something went wrong. send airtime response test failing"
  end
end

# //////////////////////// VOICE /////////////////////////////////////////
RSpec::Matchers.define :inspect_CallResponse do |expected|
  status = []
  match do |actual|
    # binding.pry
    # binding.pry
    if !actual.entries.nil?
      obj = actual.entries.collect { |item| 
        expect(item).to have_attributes(:phoneNumber => a_value, :status => a_value )
      }
      (obj.all? {|e| e.eql? true} && (actual.errorMessage.eql?("None") || actual.errorMessage.nil?))
    else
      # binding.pry
      actual.errorMessage.eql?("None") || actual.errorMessage.nil?
    end
  end
  failure_message_when_negated do |actual|
    "something went wrong. call response test failing"
  end
end


RSpec::Matchers.define :inspect_QueuedCallsResponse do |expected|
  status = []
  match do |actual|
    # binding.pry
    # binding.pry
    if !actual.entries.nil?
      obj = actual.entries.collect { |item| 
        expect(item).to have_attributes(:numCalls => a_value, :phoneNumber => a_value, :queueName => a_value)
      }
      (obj.all? {|e| e.eql? true} && !actual.status.nil? && (actual.errorMessage.eql?("None") || actual.errorMessage.nil?))
    else
      # binding.pry
      actual.errorMessage.eql?("None") || actual.errorMessage.nil?
    end
  end
  failure_message_when_negated do |actual|
    "something went wrong. fetch queued calls response test failing"
  end
end
