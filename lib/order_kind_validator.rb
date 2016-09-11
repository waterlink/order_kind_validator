class OrderKindValidator
  def validate(order)
    kinds = order[:kind]

    if empty?(kinds)
      fail_with("Order kind can not be empty")
    end

    unless valid?(kinds)
      fail_with("Order kind can be one of: 'private', 'corporate', 'bundle'")
    end

    unless has_required?(kinds)
      fail_with("Order kind should be 'private' or 'corporate'")
    end

    if has_conflicts?(kinds)
      fail_with("Order kind can not be 'private' and 'corporate' at the same time")
    end
  end

  def has_conflicts?(kinds)
    kinds.include?("private") &&
        kinds.include?("corporate")
  end

  def has_required?(kinds)
    kinds.uniq != %w(bundle)
  end

  ALLOWED_ORDER_KINDS = %w(private corporate bundle)

  def valid?(kinds)
    kinds.all? { |kind|
      ALLOWED_ORDER_KINDS.include?(kind)
    }
  end

  def empty?(kinds)
    empty_value?(kinds) ||
        kinds.any? { |kind| empty_value?(kind) }
  end

  def empty_value?(value)
    value.nil? || value.empty?
  end

  def fail_with(message)
    raise InvalidOrderError, message
  end
end

class InvalidOrderError < StandardError;
end