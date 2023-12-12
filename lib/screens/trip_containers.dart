import 'package:flutter/material.dart';
import 'package:route_optima_mobile_app/models/temp_trip.dart';
import 'package:route_optima_mobile_app/screens/parcel_list_screen.dart';

Container getNextMonthContainer(
    BuildContext context, List<Trip> trips, int index,
    {bool isAssignedList = true}) {
  return Container(
    width: double.infinity,
    height: 154.0,
    child: Column(
      children: [
        // New Month Trip Container
        Container(
          width: double.infinity,
          height: 40.0,
          margin: EdgeInsets.only(top: 8.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              '${trips[index].month} ${trips[index].year}',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        // Normal trip container
        getNormalContainer(context, trips, index, false,
            isAssignedList: isAssignedList),
      ],
    ),
  );
}

Container getNormalContainer(
    BuildContext context, List<Trip> trips, int index, bool sameDate,
    {bool isAssignedList = true}) {
  return Container(
    width: double.infinity,
    height: 90.0,
    margin: EdgeInsets.only(
      top: sameDate ? 4.0 : 16.0,
    ),
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: sameDate
              ? const SizedBox.expand()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 8.0, 0.0, 0.0),
                      child: Text(
                        trips[index].day,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 8.0, 0.0, 0.0),
                      child: Text(
                        trips[index].date,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            decoration: index == 0 && isAssignedList && isAssignedList
                ? BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade900, // Dark blue color
                        Colors.blue, // Light blue color
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  )
                : BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${trips[index].startTime} - ${trips[index].endTime}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: index == 0 && isAssignedList
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: [
                          // Location Icon
                          Icon(
                            Icons.location_pin,
                            color: index == 0 && isAssignedList
                                ? Colors.white
                                : Colors.grey,
                          ),
                          const SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            '3 Parcels',
                            style: TextStyle(
                                color: index == 0 && isAssignedList
                                    ? Colors.white
                                    : Colors.grey,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Move to Parcel List screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ParcelListPage()),
                          );
                        },
                        icon: Icon(
                          Icons.navigate_next,
                          color: index == 0 && isAssignedList
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
