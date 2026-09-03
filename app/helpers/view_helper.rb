module ViewHelper
    def govuk_back_link_to(url = :back, body = 'Back', force_text: false)
    classes = 'govuk-!-display-none-print'

    url = back_link_url if url == :back

    text = if force_text.present?
             body
           end

    text ||= body

    render GovukComponent::BackLinkComponent.new(
      text: text,
      href: url,
      classes:,
    )
  end
end
