module TrackingHelper
  def self.ali_to_shopify_tracking_company(ali_tracking_company)
    # convert the aliexpress tracking company names to the names that shopify expect
    case ali_tracking_company
    when 'Royal Mail'
      'Royal Mail'
    when 'Fedex IP'
      'FedEx'
    else
      'Other'
    end
  end

  def self.get_tracking_url(ali_tracking_company, tracking_code)
    # gets the tracking url from the tracking company and tracking code
    # returns nil if no url should be provided thus letting shopify handling it
    case ali_tracking_company
    when 'ePacket'
      "https://track.aftership.com/china-ems/#{tracking_code}"
    when 'China Post Registered Air Mail'
      "https://track.aftership.com/china-post/#{tracking_code}"
    when 'One World Express'
      "https://track.aftership.com/oneworldexpress/#{tracking_code}"
    else
      nil
    end
  end
end
