include "console.iol"
include "string_utils.iol"
include "json_utils.iol"

include "InterfaceAPI.iol"

inputPort DockerIn {
	Location: "socket://localhost:8008"
	Protocol: sodep
	Interfaces: InterfaceAPI
}

outputPort DockerD {
  Location: "socket://192.168.99.100:2357"
  Protocol: http {
    .debug=1;
    .debug.showContent=1;
    .format="json";
    .osc.containers.alias = "containers/json";
    .osc.containers.method = "get";
    .osc.containers.method.queryFormat = "json";
    .osc.inspect.alias = "containers/%!{id}/json";
    .osc.inspect.method = "get";
    .osc.inspect.method.queryFormat = "json";
    .osc.listRunProcesses.alias = "containers/%!{id}/top";
    .osc.listRunProcesses.method = "get";
    .osc.listRunProcesses.method.queryFormat = "json";
    .osc.logs.alias = "containers/%!{id}/logs";
    .osc.logs.method = "get";
    .osc.logs.method.queryFormat = "json";
    .osc.images.alias = "images/json";
    .osc.images.method = "get";
    .osc.images.method.queryFormat = "json";
    .osc.inspectImage.alias = "images/%!{name}/json";
    .osc.inspectImage.method = "get";
    .osc.inspectImage.method.queryFormat = "json";
    .osc.imageHistory.alias = "images/%!{name}/history";
    .osc.imageHistory.method = "get";
    .osc.imageHistory.method.queryFormat = "json";
    .osc.imageSearch.alias = "images/search";
    .osc.imageSearch.method = "get";
    .osc.imageSearch.method.queryFormat = "json";
    .osc.removeImage.alias = "images/%!{name}";
    .osc.removeImage.method = "delete";
    .osc.removeImage.method.queryFormat = "json";
    .osc.exportImage.alias = "images/%!{name}/get";
    .osc.exportImage.method = "get";
    .osc.exportImage.method.queryFormat = "json";
    .osc.changesOnCtn.alias = "containers/%!{id}/changes";
    .osc.changesOnCtn.method = "get";
    .osc.changesOnCtn.method.queryFormat = "json";
    .osc.exportContainer.alias = "containers/%!{id}/export";
    .osc.exportContainer.method = "get";
    .osc.exportContainer.method.queryFormat = "json";
    .osc.statsContainer.alias = "containers/%!{id}/stats";
    .osc.statsContainer.method = "get";
    .osc.statsContainer.method.queryFormat = "json";
    .osc.networks.alias = "networks";
    .osc.networks.method = "get";
    .osc.networks.method.queryFormat = "json";
    .osc.inspectNetwork.alias = "networks/%!{id}";
    .osc.inspectNetwork.method = "get";
    .osc.inspectNetwork.method.queryFormat = "json";
    .osc.volumes.alias = "volumes";
    .osc.volumes.method = "get";
    .osc.volumes.method.queryFormat = "json";
    .osc.inspectVolume.alias = "volumes/%!{name}";
    .osc.inspectVolume.method = "get";
    .osc.inspectVolume.method.queryFormat = "json";
    .osc.createContainer.alias = "containers/create";
    .osc.createContainer.method = "post";
    .osc.createContainer.method.queryFormat = "json";
    .osc.startContainer.alias = "containers/%!{id}/start";
    .osc.startContainer.method = "post";
    .osc.startContainer.method.queryFormat = "json";
    .osc.renameContainer.alias = "containers/%!{id}/rename";
    .osc.renameContainer.method = "post";
    .osc.renameContainer.method.queryFormat = "json";
    .osc.stopContainer.alias = "containers/%!{id}/stop";
    .osc.stopContainer.method = "post";
    .osc.stopContainer.method.queryFormat = "json";
		.osc.removeContainer.alias = "containers/%!{id}";
    .osc.removeContainer.method = "delete";
    .osc.removeContainer.method.queryFormat = "json";
		.osc.restartContainer.alias = "containers/%!{id}/restart";
    .osc.restartContainer.method = "post";
    .osc.restartContainer.method.queryFormat = "json";
		.osc.build.alias = "build";
    .osc.build.method = "post";
    .osc.build.method.queryFormat = "json";
		.osc.createVolume.alias = "volumes/create";
    .osc.createVolume.method = "post";
    .osc.createVolume.method.queryFormat = "json";
		.osc.removeVolume.alias = "volumes/%!{name}";
    .osc.removeVolume.method = "delete";
    .osc.removeVolume.method.queryFormat = "json";
		.osc.removeNetwork.alias = "networks/%!{id}";
    .osc.removeNetwork.method = "delete";
    .osc.removeNetwork.method.queryFormat = "json";
		.osc.createNetwork.alias = "networks/create";
    .osc.createNetwork.method = "post";
    .osc.createNetwork.method.queryFormat = "json";
		.osc.killContainer.alias = "containers/%!{id}/kill";
    .osc.killContainer.method = "post";
    .osc.killContainer.method.queryFormat = "json"
  }
  RequestResponse:
	build,
	changesOnCtn,
	containers,
	createContainer,
	createNetwork,
	createVolume,
	exportContainer,
	exportImage,
	images,
	imageHistory,
	imageSearch,
	inspect,
	inspectImage,
	inspectNetwork,
	inspectVolume,
	killContainer,
	listRunProcesses,
	logs,
	networks,
	removeContainer,
	removeImage,
	removeNetwork,
	removeVolume,
	renameContainer,
	restartContainer,
	startContainer,
	statsContainer,
	stopContainer,
	volumes
}
// DA METTERE IN ORDINE ALFABETICO!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
main {
  [ containers( request )( response ) {
    if( !(is_defined( request.all ))){
      request.all = false
    };
    if( !(is_defined( request.size ))){
      request.size = false
    };
    containers@DockerD( request )( responseByDocker );
    response.container<<responseByDocker._
  }]


  [ inspect( request )( response ) {
    inspect@DockerD( request )( responseByDocker );
    response<<responseByDocker
  }]


  [ listRunProcesses( request )( response ) {
    if( !(is_defined( request.ps_args ))){
      request.ps_args="-ef"
    };
    listRunProcesses@DockerD(  request  )(  responseByDocker  );
    response.Titles<<responseByDocker.Titles;
    response.Processes.row<<responseByDocker.Processes._
  }]


  [ logs( request )( response ){
    if( !( is_defined( request.follow ))){
      request.follow = false
    };
    if( !( is_defined( request.stderr ))){
      request.stderr = false
    };
    if( !( is_defined( request.stdout ))){
      request.stdout = false
    };
    if( !( is_defined( request.since ))){
      request.since = 0
    };
    if( !( is_defined( request.timestamps ))){
      request.timestamps = false
    };
    if( !( is_defined( request.tail ))){
      request.tail = "all"
    };
    logs@DockerD( request )( responseByDocker );
    response.log<<responseByDocker
  }]


  [ images( request )( response ){
    if( !( is_defined(  request.all  ))){
      request.all = false
    };
    if(  !( is_defined( request.digest ))){
      request.digest = false
    };
    images@DockerD( request )( responseByDocker );
    response.images<<responseByDocker._
  }]


  [ inspectImage( request )( response ){
    inspectImage@DockerD( request )( responseByDocker );
    response<<responseByDocker
  }]


  [ imageHistory( request )( response ){
    imageHistory@DockerD( request )( responseByDocker );
    response.histories<<responseByDocker._
  }]


  [ imageSearch( request )( response ){
    imageSearch@DockerD( request )( responseByDocker );
    response.results<<responseByDocker._
  }]


  [ removeImage( request )( response ){
    if( !(is_defined( request.force ))){
      request.force = false
    };
    if( !(is_defined( request.noprune ))){
      request.noprune = false
    };
    removeImage@DockerD( request )( responseByDocker );
    response.info<<responseByDocker._
  }]


  [ exportImage( request )( response ){
    exportImage@DockerD( request )( responseByDocker );
    response.exporting<<responseByDocker
  }]


  [ changesOnCtn( request )( response ){
    changesOnCtn@DockerD( request )( responseByDocker );
    response.changes<<responseByDocker._
  }]


  [ exportContainer( request )( response ){
    exportContainer@DockerD( request )( responseByDocker );
    response<<responseByDocker
  }]


  [ statsContainer( request )( response ){
    if( !(is_defined( request.stream ))){
      request.stream = false
    };
    statsContainer@DockerD( request )( responseByDocker );
    response<<responseByDocker
  }]
  [ networks( request )( response ){
    networks@DockerD( request )( responseByDocker );
    response.network<<responseByDocker._
  }]


  [ inspectNetwork( request )( response ){
    inspectNetwork@DockerD( request )( responseByDocker );
    response.result<<responseByDocker
  }]


  [ volumes( request )( response ){
    volumes@DockerD( request )( responseByDocker );
    response<<responseByDocker
  }]


  [ inspectVolume( request )( response ){
    inspectVolume@DockerD( request )( responseByDocker );
    response<<responseByDocker
  }]


  [ createContainer( request )( response ){
    if( !(is_defined( request.AttachStdin ))){
      request.AttachStdin = false
    };
    if( !(is_defined( request.AttachStdout ))){
      request.AttachStdout = true
    };
    if( !(is_defined( request.AttachStderr ))){
      request.AttachStderr = true
    };
    if( !(is_defined( request.OpenStdin ))){
      request.OpenStdin = false
    };
    if( !(is_defined( request.StdinOnce ))){
      request.StdinOnce = false
    };
    if( !(is_defined( request.NetworkDisabled ))){
      request.NetworkDisabled = false
    };
    if( !(is_defined( request.StopSignal ))){
      request.StopSignal = "SIGTERM"
    };
    if( !(is_defined( request.StopTimeout ))){
      request.StopTimeout = 10
    };
    createContainer@DockerD( request )( responseByDocker );
    response<<responseByDocker
  }]


  [ startContainer( request )( response ){
    startContainer@DockerD( request )( responseByDocker );
    response<<responseByDocker
  }]


  [ renameContainer( request )( response ){
    renameContainer@DockerD( request )( responseByDocker );
    response<<responseByDocker
  }]


  [ stopContainer( request )( response ){
    stopContainer@DockerD( request )( responseByDocker );
    response<<responseByDocker
  }]


	[ removeContainer( request )( response ){
		removeContainer@DockerD( request )( responseByDocker );
    response<<responseByDocker
	}]


	[ restartContainer( request )( response ){
		restartContainer@DockerD( request )( responseByDocker );
    response<<responseByDocker
	}]


	[ build( request )( response ){
		if( !(is_defined( request.dockerfile ))){
      request.dockerfile = "Dockerfile"
    };
		if( !(is_defined( request.q ))){
      request.q = false
    };
		if( !(is_defined( request.nocache ))){
      request.nocache = false
    };
		if( !(is_defined( request.rm ))){
      request.rm = true
    };
		if( !(is_defined( request.forcerm ))){
      request.forcerm = false
    };
		if( !(is_defined( request.Content_type ))){
      request.Content_type = "application/tar"
    };
		build@DockerD( request )( responseByDocker );
    response<<responseByDocker
	}]


	[ createVolume( request )( response ){
		createVolume@DockerD( request )( responseByDocker );
    response<<responseByDocker
	}]


	[ removeVolume( request )( response ){
		if( !(is_defined( request.force ))){
      request.force = false
    };
		removeVolume@DockerD( request )( responseByDocker );
    response<<responseByDocker
	}]


	[ removeNetwork( request )( response ){
		removeNetwork@DockerD( request )( responseByDocker );
    response<<responseByDocker
	}]


	[ createNetwork( request )( response ){
		if( !(is_defined( request.Driver ))){
      request.Driver = "bridge"
    };
		createNetwork@DockerD( request )( responseByDocker );
    response<<responseByDocker
	}]


	[killContainer( request )( response ){
		if( !(is_defined( request.signal ))){
      request.signal = "SIGKILL"
    };
		killContainer@DockerD( request )( responseByDocker );
    response<<responseByDocker
	}]
}
