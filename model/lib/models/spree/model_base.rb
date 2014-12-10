module Spree
  class ModelBase

    private

    def block_states(action, states)
      states.each do |state|
        raise Spree::IllegalOperation.new("Cannot call #{action} when #{self.class} is in #{state} state") if self.send(state)
      end
    end

    def require_states(action, states)
      states.each do |state|
        raise Spree::IllegalOperation.new("Cannot call #{action} unless #{self.class} is in #{state} state") unless self.send(state)
      end
    end
  end
end