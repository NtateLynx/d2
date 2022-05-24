module Mutations
  class UpdateSchoolLink < ApplicationQuery
    class SchoolLinkMustBePresent < GraphQL::Schema::Validator
      def validate(_object, _context, value)
        link = SchoolLink.find_by(id: value[:id])

        return "Unable to find link with id: #{value[:id]}" if link.blank?
      end
    end

    include QueryAuthorizeSchoolAdmin
    include ValidateSchoolLinkEditable

    argument :id, ID, required: true
    argument :title, String, required: false
    argument :url, String, required: false

    description 'Update school header/footer/social links'

    field :success, Boolean, null: false

    validates SchoolLinkMustBePresent => {}

    def resolve(_params)
      notify(
        :success,
        I18n.t('shared.done_exclamation'),
        I18n.t('mutations.update_school_link.success_notification')
      )

      { success: update_school_link }
    end

    def update_school_link
      school_link.update!(school_link_data)
    end

    private

    def school_link
      SchoolLink.find_by(id: @params[:id])
    end

    def resource_school
      current_school
    end
  end
end
