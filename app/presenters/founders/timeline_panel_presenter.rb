module Founders
  class TimelinePanelPresenter < ApplicationPresenter
    def initialize(event, founder, current_founder)
      @event = event
      @founder = founder
      @current_founder = current_founder
    end

    def detailed_description
      "After #{target_prefix(@event.target)} <em>#{@event.target.title}:</em>\n #{@event.description}"
    end

    def needs_improvement_tooltip_text(current_founder, founder)
      if current_founder && (current_founder == founder)
        needs_improvement_tooltip_for_founder(@event)
      else
        needs_improvement_tooltip_for_public(@event)
      end
    end

    def needs_improvement_status_text
      if @event.improved_timeline_event.present?
        I18n.t('startups.show.timeline_cards.improved_later.status_text')
      else
        I18n.t('startups.show.timeline_cards.needs_improvement.status_text')
      end
    end

    def review_pending?
      @event.evaluator_id.blank? && !@event.passed?
    end

    def not_accepted?
      @event.evaluator_id.present? && !@event.passed?
    end

    def improved_event?
      @founder.startup.earliest_team_event_date.present? && !@event.founder_event? && @event.passed?
    end

    def founder?
      @current_founder && (@current_founder == @founder)
    end

    def founder_not_exited?
      @current_founder && !@current_founder.exited && (@current_founder == @founder)
    end

    def attachments
      @event.attachments_for_founder(@current_founder)
    end

    private

    def target_prefix(target)
      case target.target_action_type
        when Target::TYPE_TODO
          'executing'
        when Target::TYPE_ATTEND
          'attending'
        when Target::TYPE_LEARN
          'watching'
        when Target::TYPE_READ
          'reading'
      end
    end

    def needs_improvement_tooltip_for_founder(event)
      if event.improved_timeline_event.present?
        I18n.t('startups.show.timeline_cards.improved_later.tooltip_text.founder')
      else
        I18n.t('startups.show.timeline_cards.needs_improvement.tooltip_text.founder')
      end
    end

    def needs_improvement_tooltip_for_public(event)
      if event.improved_timeline_event.present?
        I18n.t('startups.show.timeline_cards.improved_later.tooltip_text.public')
      else
        I18n.t('startups.show.timeline_cards.needs_improvement.tooltip_text.public')
      end
    end
  end
end