import 'package:route_optima_mobile_app/models/dummy_route.dart';

Map<String, dynamic> generateStats(List<DummyRoute> routes) {
  int onTimeDeliveries = 0;
  int lateDeliveries = 0;
  double totalDistance = 0;
  double totalWorkingHours = 0;
  List<double> distances = [];
  List<double> workingHours = [];

  // Generate random number between 0 and 1
  double random = (DateTime.now().millisecondsSinceEpoch % 1000) / 1000;
  // Genrate a random integer between 0 and 5
  int randomInt = (DateTime.now().millisecondsSinceEpoch % 1000) % 5;

  for (var route in routes) {
    if (route.onTime) {
      if (random < 0.2) {
        onTimeDeliveries += 2;
      } else {
        onTimeDeliveries++;
      }
    } else {
      if (random < 0.5) {
        onTimeDeliveries++;
      } else {
        lateDeliveries++;
      }
    }

    double currentDistance = 0;

    if (random < 0.5) {
      currentDistance = route.distance + randomInt;
    } else {
      currentDistance = route.distance - randomInt;
    }

    totalDistance += currentDistance;
    distances.add(currentDistance);
    double hours =
        route.arrivalTime.difference(route.departureTime).inHours.toDouble();
    if (random < 0.5) {
      hours += randomInt;
    } else {
      hours -= randomInt;
    }
    totalWorkingHours += hours;
    workingHours.add(hours);
  }

  double averageDistance =
      distances.isNotEmpty ? totalDistance / routes.length : 0;
  double averageWorkingHours =
      workingHours.isNotEmpty ? totalWorkingHours / workingHours.length : 0;

  return {
    'onTimeDeliveries': onTimeDeliveries,
    'lateDeliveries': lateDeliveries,
    'averageDistance': averageDistance,
    'averageWorkingHours': averageWorkingHours,
    'distances': distances,
    'workingHours': workingHours,
  };
}

Map<String, dynamic> generateYearlyStats(List<DummyRoute> routes) {
  Map<String, List<DummyRoute>> routesByYear = {};

  for (var route in routes) {
    int year = route.assignedDate.year;
    routesByYear.putIfAbsent(year.toString(), () => []).add(route);
  }

  Map<String, dynamic> yearlyStats = {};

  routesByYear.forEach((year, yearDummyRoutes) {
    yearlyStats[year] = generateStats(yearDummyRoutes);
  });

  return yearlyStats;
}

Map<String, dynamic> generateMonthlyStats(List<DummyRoute> routes) {
  Map<String, List<DummyRoute>> routesByMonth = {};

  for (var route in routes) {
    // int year = route.assignedDate.year;
    int month = route.assignedDate.month;
    String key = '$month';
    routesByMonth.putIfAbsent(key, () => []).add(route);
  }

  Map<String, dynamic> monthlyStats = {};

  routesByMonth.forEach((key, monthDummyRoutes) {
    monthlyStats[key] = generateStats(monthDummyRoutes);
  });

  return monthlyStats;
}

Map<String, dynamic> get yearlyStats {
  return generateYearlyStats(dummyRoutes);
}

Map<String, dynamic> get monthlyStats {
  return generateMonthlyStats(dummyRoutes);
}
