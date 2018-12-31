class CalendarFeedsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  before_action :authenticate

  def show
    access_token = require_valid_access_token!

    render_headers

    @calendar = Calendar.new(access_token.issuer)

    if @calendar.empty?
      render "empty"
    end
  end

  private

  def require_valid_access_token!
    AccessToken.find_granted_by_slug!(
      slug: params[:id],
      grantee: current_character,
    )
  end

  # def render_ical(calendar)
  #   send_data generate_feed(calendar),
  #     filename: "basic.ics",
  #     type: "text/calendar; charset=utf-8",
  #     disposition: :inline
  # end

  # def generate_feed(calendar)
  #   buffer = []

  #   buffer << "BEGIN:VCALENDAR"
  #   buffer << "VERSION:2.0"
  #   buffer << "PRODID:eventical"
  #   buffer << "CALSCALE:GREGORIAN"
  #   buffer << "METHOD:PUBLISH"
  #   # buffer << "X-WR-CALNAME:#{calendar.display_name}"
  #   # buffer << "X-WR-TIMEZONE;VALUE=TEXT:#{calendar.time_zone.name}"
  #   # buffer << "LAST-MODIFIED:#{format_datetime(calendar.last_modified_at)}"
  #   #   BEGIN:VEVENT
  #   #   DTSTAMP:20181216T074451Z
  #   #   UID:a4359af6-dc68-451e-a415-074c721858d8
  #   #   DTSTART:20181216T074451
  #   #   SUMMARY:Robyn Dibbert
  #   #   END:VEVENT
  #   #   END:VCALENDAR
  #   buffer << "END:VCALENDAR"

  #   buffer.compact.join("\r\n")
  # end

  def render_headers
    response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = Time.utc(1990, 1, 1).rfc2822
    response.headers["Date"] = Time.current.utc.rfc2822
  end

  def record_not_found
    render plain: "404 Not Found", status: 404
  end
end
