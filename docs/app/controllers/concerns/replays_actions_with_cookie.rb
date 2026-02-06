module ReplaysActionsWithCookie
  def self.included(base)
    base.cattr_accessor :cookie_name_prefix
  end

  private

  def replay_cookie_name(table_id)
    "#{cookie_name_prefix}_#{table_id}"
  end

  def replay_cookie_value(id)
    cookie_name = replay_cookie_name(id)
    cookies[cookie_name]
  end

  def reset_replay_cookie(id)
    cookie_name = replay_cookie_name(id)
    cookies.delete(cookie_name)
  end

  def append_bulk_delete_to_cookie_actions(id, ids:)
    ids = Array(ids).map(&:to_s)
    cookie_name = replay_cookie_name(id)
    actions = cookie_actions_to_replay(id)
    actions << { "type" => "bulk_delete", "ids" => ids }

    cookies[cookie_name] = {
      value: actions.to_json,
      path: "/",
      expires: 1.year.from_now
    }
  end

  def cookie_actions_to_replay(id)
    raw = replay_cookie_value(id)
    return [] if raw.blank?
    JSON.parse(raw)
  rescue JSON::ParserError
    []
  end

  def replay_cookie_actions(id, records)
    actions = cookie_actions_to_replay(id)
    ids_to_delete = Set.new

    actions.each do |action|
      case action["type"]
      when "bulk_delete"
        ids_to_delete.merge(action["ids"])
      else
        Rails.logger.warn "Invalid action type: #{action["type"].inspect}"
      end
    end

    return records if ids_to_delete.empty?
    records.dup.delete_if { |record| ids_to_delete.include?(record.id.to_s) }
  end
end
