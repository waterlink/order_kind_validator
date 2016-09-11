RSpec.describe OrderKindValidator do
  subject(:validator) { described_class.new }

  class ItFailsWith
    def initialize(spec, expected_message)
      @spec = spec
      @expected_message = expected_message
    end

    def when_order_kind_is_absent
      expect_failure("absent", {items: 42})
    end

    def when_order_kind_is(value)
      expect_failure(value.inspect, {items: 42, kind: value})
    end

    private

    def expect_failure(feature, order, expected_message = @expected_message)
      @spec.it("fails with message #{expected_message.inspect} when order kind is #{feature}") do
        expect { validator.validate(order) }
            .to raise_error(InvalidOrderError, expected_message)
      end
    end
  end

  def self.it_fails_with(message)
    ItFailsWith.new(self, message)
  end

  class ItDoesNotFail
    def initialize(spec)
      @spec = spec
    end

    def when_order_kind_is(value)
      @spec.it("does not fail when order kind is #{value.inspect}") do
        expect { validator.validate({items: 42, kind: value}) }
            .not_to raise_error
      end
    end
  end

  def self.it_does_not_fail
    ItDoesNotFail.new(self)
  end

  it_fails_with("Order kind can not be empty").when_order_kind_is_absent
  it_fails_with("Order kind can not be empty").when_order_kind_is([])
  it_fails_with("Order kind can not be empty").when_order_kind_is([nil])
  it_fails_with("Order kind can not be empty").when_order_kind_is([""])
  it_fails_with("Order kind can not be empty").when_order_kind_is(["private", ""])

  it_does_not_fail.when_order_kind_is(%w(private))
  it_does_not_fail.when_order_kind_is(%w(private private))
  it_does_not_fail.when_order_kind_is(%w(corporate))
  it_does_not_fail.when_order_kind_is(%w(corporate corporate))
  it_does_not_fail.when_order_kind_is(%w(private bundle))

  it_fails_with("Order kind can be one of: 'private', 'corporate', 'bundle'")
      .when_order_kind_is(%w(invalid))

  it_fails_with("Order kind can be one of: 'private', 'corporate', 'bundle'")
      .when_order_kind_is(%w(private invalid))

  it_fails_with("Order kind can be one of: 'private', 'corporate', 'bundle'")
      .when_order_kind_is(%w(private another_invalid))

  it_fails_with("Order kind can be one of: 'private', 'corporate', 'bundle'")
      .when_order_kind_is(%w(invalid private))

  it_fails_with("Order kind should be 'private' or 'corporate'")
      .when_order_kind_is(%w(bundle))

  it_fails_with("Order kind should be 'private' or 'corporate'")
      .when_order_kind_is(%w(bundle bundle))

  it_fails_with("Order kind can not be 'private' and 'corporate' at the same time")
      .when_order_kind_is(%w(private corporate))

  it_fails_with("Order kind can not be 'private' and 'corporate' at the same time")
      .when_order_kind_is(%w(corporate private))
end