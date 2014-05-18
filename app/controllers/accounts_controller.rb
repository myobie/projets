class AccountsController < ApplicationController
  def index
    render_json current_user.accounts.map(&AccountRepresentation)
  end
end
