class TweetsController < ItemController
  def show
    @tweet = Tweet.find(params[:id])
    redirect_to @tweet.external_url
  end
end
