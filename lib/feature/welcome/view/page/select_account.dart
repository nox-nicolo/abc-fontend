import 'package:flutter/material.dart';

class SelectAccount extends StatelessWidget {
  const SelectAccount( 
    {
      super.key, 
    }
  ); 

  @override 
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Select Account', 
              style: Theme.of(context).textTheme.headlineLarge,
            ), 
            const SizedBox(height: 25,),
            SizedBox(
              width: size.width * .95,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context, 
                    '/signup', 
                    (route) => false, // This removes ALL previous routes
                    arguments: {'isCustomer': true},
                  );
                }, 
                child: Text(
                  'Customer', 
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              ),
            ), 
            const SizedBox(height: 15,),
            SizedBox(
              width: size.width * .95,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context, 
                    '/signup', 
                    (route) => false, // This removes ALL previous routes
                    arguments: {'isCustomer': false},
                  );
                }, 
                child: Text(
                  'Salon', 
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}