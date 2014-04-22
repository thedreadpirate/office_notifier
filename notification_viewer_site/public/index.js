var app = angular.module('notifier', ['ngResource'])

app.controller('listCtrl', ['$scope', '$resource', function($scope, resource){
   $scope.test = ['one', 'two'];

  var notifications = resource('/notification/:tag', {tag: '@tag'});

  $scope.notifications = notifications.query();

  $scope.submitMessage = function(){
    notifications.save($scope.newMessage);
  }
}]);
