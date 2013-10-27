class ContentController < ApplicationController
  before_filter :authenticate_user!

end