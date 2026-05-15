{{flutter_js}}
{{flutter_build_config}}

(function() {
  var loading = document.getElementById('flutter_loading');
  if (loading) {
    _flutter.loader.load({
      onEntrypointLoaded: async function(engineInitializer) {
        var appRunner = await engineInitializer.initializeEngine();
        loading.style.display = 'none';
        await appRunner.runApp();
      }
    });
  } else {
    _flutter.loader.load();
  }
})();
