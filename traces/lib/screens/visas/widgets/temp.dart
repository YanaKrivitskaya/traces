//google nav bar
      /*bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: [
                GButton(
                  icon: LineIcons.calendar,
                  text: 'Overview',
                ),
                GButton(
                  icon: LineIcons.file,
                  text: 'Notes',
                ),
                GButton(
                  icon: LineIcons.map,
                  text: 'Itinerary',
                ),
                GButton(
                  icon: LineIcons.check,
                  text: 'Actions',
                ),
              ],
              selectedIndex: 0,
              onTabChange: (index) {
                setState(() {
                  //_selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),*/    