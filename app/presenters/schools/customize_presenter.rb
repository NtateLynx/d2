module Schools
  class CustomizePresenter < ApplicationPresenter
    def json_props
      {
        authenticityToken: view.form_authenticity_token,
        customizations: {
          strings: school_strings,
          images: school_images,
          headerLinks: header_links,
          footerLinks: footer_links,
          socialLinks: social_links
        },
        schoolName: current_school.name
      }.to_json
    end

    private

    def school_strings
      {
        address: address,
        emailAddress: SchoolString::EmailAddress.for(current_school),
        privacyPolicy: SchoolString::PrivacyPolicy.for(current_school),
        termsOfUse: SchoolString::TermsOfUse.for(current_school)
      }
    end

    def address
      a = SchoolString::Address.for(current_school)
      a.present? ? view.simple_format(a) : nil
    end

    def school_images
      {
        logoOnLightBg: current_school.logo_on_light_bg.attached? ? view.url_for(current_school.logo_on_light_bg) : nil,
        logoOnDarkBg: current_school.logo_on_dark_bg.attached? ? view.url_for(current_school.logo_on_dark_bg) : nil,
        icon: current_school.icon.attached? ? view.url_for(current_school.icon) : nil
      }
    end

    def header_links
      current_school.school_links.where(kind: SchoolLink::KIND_HEADER).as_json(only: %i[title url])
    end

    def footer_links
      current_school.school_links.where(kind: SchoolLink::KIND_FOOTER).as_json(only: %i[title url])
    end

    def social_links
      current_school.school_links.where(kind: SchoolLink::KIND_SOCIAL).pluck(:url)
    end
  end
end
