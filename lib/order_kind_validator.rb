class OrderKindValidator
  def validate(order)
    kinds = order[:kind]

    validate_non_empty(kinds)

    validate_only_known(kinds)
    validate_has_required(kinds)
    validate_no_conflicting(kinds)
  end

  private

  def validate_non_empty(kinds)
    if empty?(kinds)
      fail_with("Order kind can not be empty")
    end
  end

  def validate_no_conflicting(kinds)
    if has_conflicting?(kinds)
      fail_with("Order kind can not be 'private' and 'corporate' at the same time")
    end
  end

  def validate_has_required(kinds)
    if has_no_required?(kinds)
      fail_with("Order kind should be 'private' or 'corporate'")
    end
  end

  def validate_only_known(kinds)
    if invalid?(kinds)
      fail_with("Order kind can be one of: 'private', 'corporate', 'bundle'")
    end
  end

  def empty?(kinds)
    absent_or_empty?(kinds) ||
        kinds.any? { |kind| absent_or_empty?(kind) }
  end

  def absent_or_empty?(value)
    value.nil? || value.empty?
  end

  def has_conflicting?(kinds)
    (%w(private corporate) - kinds).empty?
  end

  def has_no_required?(kinds)
    (kinds - %w(private corporate)) == kinds
  end

  def invalid?(kinds)
    (kinds - %w(private corporate bundle)).any?
  end

  def fail_with(message)
    raise InvalidOrderError.new(message)
  end
end

class InvalidOrderError < StandardError
end