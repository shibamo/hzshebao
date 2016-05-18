/**Angular application module for function Organization Charge Total,
to reduce unneccessary page switching with server side rendering for the user
TO-DO:  
        1.  move the controller/service/filter/directive implementation to separate js file when the business 
            logic exploding to a certain level.
        2.  文件成功上传后如何把message传给主页面进行显示,以及给相应上传->已上传加上转换的动画效果
**/
(()=>{
  angular.module('organization_charge_totals', 
    ['ngResource','ngFileUpload','ui.router','ngDialog','ngAnimate','ngMessages']).
  config(['$stateProvider','$urlRouterProvider','$httpProvider',
  ($stateProvider,$urlRouterProvider,$httpProvider)=>{
    //Make the default url to 财务处理-机构常规资金核对[Menu] => 机构缴费记录列表(等待资金到账核对)[Page Title]
    $urlRouterProvider.otherwise('');

    //设置各页面状态,路径,模板,Controller
    $stateProvider.state('list_money_arrival_check', {//主界面,机构缴费记录列表
        url: '',
        controller: 'ListMoneyArrivalCheckController',
        templateUrl: '/organization_charge_totals/table_ng' 
    }).state('set_money_arrival_date',{//设置日期
        url: '/set_money_arrival_date/:id/:organization_abbr',
        controller: 'SetMoneyArrivalDateController',
        templateUrl: '/organization_charge_totals/set_money_arrival_date_ng' 
    }).state('upload_money_arrival_file',{//上传
        url: '/upload_money_arrival_file/:id/:business_type/:extra_data/:business_action',
        controller: 'UploadMoneyArrivalFileController',
        templateUrl: '/money_arrival_files/new_ng' 
    });

    //缺省设置CSRF 
    $httpProvider.defaults.headers.patch = {"Content-Type": "application/json;charset=UTF8", //此处如果不显式设置,json会变成html
                                            "X-CSRF-Token": $("meta[name='csrf-token']").attr('content')};
    $httpProvider.defaults.headers.get = {"X-CSRF-Token": $("meta[name='csrf-token']").attr('content')};


  }]). //机构缴费记录列表-Controller
  controller('ListMoneyArrivalCheckController', 
  ['$scope','$rootScope','ngDialog','$http','$interval','$filter','numberConvertService','organizationChargeTotalDataService',
  function($scope,$rootScope,ngDialog,$http,$interval,$filter,numberConvertService,organizationChargeTotalDataService){
    var stopInterval;                                                  
    $scope.messages = {noticeA: "", noticeB: "", error: ""};
    $scope.successCount = 0;                                                  
    $scope.parseFloat = parseFloat;

    organizationChargeTotalDataService.getOCTData($scope);

    stopInterval = $interval(()=>{//使用定时器更新主数据表
      organizationChargeTotalDataService.getOCTData($scope); 
    },60000);
    $scope.$on('$destroy', ()=>{//退出前释放定时器资源
      if(angular.isDefined(stopInterval)){
        $interval.cancel(stopInterval);
        stopInterval = undefined;
      }
    });

    $scope.$on('$viewContentLoaded',function(event,data){ //重新载入时更新主数据表
      organizationChargeTotalDataService.getOCTData($scope);
    });
    $scope.finish_money_check = (id)=>{//提交确认到账
      $http({ method:'get',
              url: `/organization_charge_totals/finish_money_check_ng/${id}`})
      .then(
        function (resp) {
          $scope.successCount++;
          $scope.messages["noticeA"] = $scope.messages["noticeA"] ? "" : `确认到账操作已成功! +${$scope.successCount}`;
          $scope.messages["noticeB"] = $scope.messages["noticeA"] ? "" : `确认到账操作已成功! +${$scope.successCount}`;
          _.remove($scope.entities, (entity)=>{return entity.id==id});
        }, function (resp) {
          $scope.messages["error"] = '确认到账出错!: ' + resp.status;
      });
    };
    $scope.showShebaoDialog = (valsArr)=>{//显示社保金构成
      var valsArr = numberConvertService.toCurrency(valsArr);
      ngDialog.open({
          template: `<b><p class="text-center">社保金构成说明</p></b>
          <p class="bg-info">社保金 = 企业社保金 + 个人社保金 + 残保金</p>
          <p>企业社保金: ${valsArr[0]}</p>
          <p>个人社保金: ${valsArr[1]}</p>
          <p>残保金: ${valsArr[2]}</p>`,
          className: 'ngdialog-theme-default',
          plain: true
      });
    };
    $scope.showGongjijinDialog = (valsArr)=>{//显示公积金构成
      var valsArr = numberConvertService.toCurrency(valsArr);
      ngDialog.open({
          template: `<b><p class="text-center">公积金构成说明</p></b>
          <p class="bg-info">公积金 = 企业公积金 + 个人公积金</p>
          <p>企业公积金: ${valsArr[0]}</p><p>个人公积金: ${valsArr[1]}</p>`,
          className: 'ngdialog-theme-default',
          plain: true
      });
    };
    $scope.showOtherPlusSalaryDialog = (valsArr)=>{//显示其他+工资构成
      var valsArr = numberConvertService.toCurrency(valsArr);
      ngDialog.open({
          template: `<b><p class="text-center">其他+工资构成说明</p></b>
          <p class="bg-info">其他 + 工资 = 其它1 + 其它2 + 其它3 + 补缴 + 预缴 + 应发工资</p>
          <p>其他1: ${valsArr[0]}</p><p>其他2: ${valsArr[1]}</p><p>其他3: ${valsArr[2]}</p>
          <p>补缴: ${valsArr[3]}</p><p>预缴: ${valsArr[4]}</p><p>工资: ${valsArr[5]}</p>`,
          className: 'ngdialog-theme-default',
          plain: true
      });
    };
    $scope.showMemoDialog = (valsArr)=>{//显示备注
      var valsArr = numberConvertService.toCurrency(valsArr);
      ngDialog.open({
          template: `<b><p class="text-center">备注</p></b><p class="bg-info">${valsArr[0]}</p>`,
          className: 'ngdialog-theme-default',
          plain: true
      });
    };
  }]). //设置缴费日期-Controller
  controller('SetMoneyArrivalDateController', ['$scope','$state','$stateParams','$http','authenticityTokenService',
  function($scope,$state,$stateParams,$http,authenticityTokenService){
    $scope.id = $stateParams.id;
    $scope.organization_abbr = $stateParams.organization_abbr;
    $scope.submit = ()=>{
      if ($scope.money_arrival_date) {
        var o={};
        o.authenticity_token = authenticityTokenService.getToken();
        o.organization_charge_total = {money_arrival_date: $scope.money_arrival_date}
        $http({ method:'patch',
                url: '/organization_charge_totals/set_money_arrival_date_ng/'+$scope.id,
                data: o})
        .then(
          function (resp) {
            $state.go('list_money_arrival_check');
          }, function (resp) {
            console.log('设置收费日期出错: ' + resp.status);
        });

      } else{
        $scope.prompt = "选择完日期后才能提交!";
      }
    };
  }]). //上传缴费相关文件-Controller
  controller('UploadMoneyArrivalFileController', ['$scope', 'Upload','$state','$stateParams','authenticityTokenService', 
  function($scope, Upload, $state, $stateParams, authenticityTokenService){
    $scope.id = $stateParams.id;
    $scope.extra_data = $stateParams.extra_data.replace(".","");
    $scope.backToHome = "list_money_arrival_check()";
    $scope.submit = ()=>{
      if ($scope.form.file.$valid && $scope.file) {
        $scope.upload($scope.file);
      } else{
        $scope.prompt = "选择完文件后才能提交!";
      }
    };
    $scope.upload = (file)=>{
      Upload.upload({
          url: `/money_arrival_files/create/OrganizationChargeTotal/${$scope.extra_data}/${$scope.id}/money_arrival_check`,
          data: { "money_arrival_file[uploaded_file]": file,
                  'authenticity_token': authenticityTokenService.getToken()
                }
      }).then(function (resp) {
          console.log('Success: file uploaded. ');
          $state.go('list_money_arrival_check');
      }, function (resp) {
          console.log('Error status: ' + resp.status);
      });
    }; 
  }]). //全局模式删除字符串中指定的子字符串-Filter
  filter("stringReplacer",()=>{
    return (value, pattern, replacee)=>{
      if(angular.isString(value) && angular.isString(pattern)){
        return value.replace(new RegExp(pattern,"g"), replacee || "");
      }
      else
      {
        return value;
      }
    };
  }). //数字格式转换-Service
  service("numberConvertService",["$filter",function($filter){
    this.toCurrency = (valsArr)=>{
      return _.map(valsArr,(val)=>{ 
        return $.isNumeric(val) ? $filter('number')(val,2) : val; //参考自http://jeffdeng.me/
      });
    };
  }]). //获取服务器数据-Service
  service("organizationChargeTotalDataService",["$resource",function($resource){
    this.getOCTData = (scope)=>{
      $resource('/organization_charge_totals/list_money_arrival_check_ng.json').query((data)=>{
        scope.entities = data;
      }); 
    }
  }]).
  service("authenticityTokenService",function(){ //获取Form的authenticity_token,用于Form提交
    this.getToken = ()=>{
      return $("form input[name='authenticity_token']").val();
    };
  })
  ;
})();