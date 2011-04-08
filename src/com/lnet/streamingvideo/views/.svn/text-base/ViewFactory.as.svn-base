package com.lnet.streamingvideo.views {
	import com.lnet.streamingvideo.viewmodels.PlayerViewModel;
	import com.lnet.streamingvideo.viewmodels.SearchViewModel;

	public class ViewFactory {
		
		public static function createMainView():MainView {
			var mainView:MainView = new MainView();
			createSearchView(mainView);
			createPlayerView(mainView);
			return mainView;
		}
		
		private static function createSearchView(mainView:MainView):void {
			var searchView:SearchView = new SearchView();
			searchView.searchViewModel = new SearchViewModel();
			mainView.addElement(searchView);
		}
		
		private static function createPlayerView(mainView:MainView):void {
			var playerView:PlayerView = new PlayerView();
			playerView.playerViewModel = new PlayerViewModel();
			mainView.addElement(playerView);
		}
	}
}