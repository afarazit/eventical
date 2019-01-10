class Calendar
  attr_reader :character

  def initialize(character)
    @character = character
  end

  def agenda
    @agenda ||= Agenda.new(events: upcoming_events)
  end

  def upcoming_events
    character.
      events.
      where("starts_at >= ?", Date.current).
      order(starts_at: :asc).
      to_a
  end
end