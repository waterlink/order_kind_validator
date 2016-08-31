class OrderKindValidator
  def validate(order)
    kind = order[:kind]

    if kind == ["invalid"]
      fail_with("Order kind can be one of: 'private', 'corporate', 'bundle'")
    end

    if kind == ["bundle"]
      fail_with("Order kind should be 'private' or 'corporate'")
    end

    if kind == %w(private corporate)
      fail_with("Order kind can not be 'private' and 'corporate' at the same time")
    end

    if kind != ["private"] && kind != ["corporate"] &&
        kind != %w(private bundle) &&
        kind != %w(corporate bundle)
      fail_with("Order kind can not be empty")
    end
  end

  private

  def fail_with(message)
    raise InvalidOrderError.new(message)
  end
end

class InvalidOrderError < StandardError
end