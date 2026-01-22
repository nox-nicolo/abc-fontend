import 'package:africa_beuty/core/view_model/getmajor_viewmodel.dart';
import 'package:africa_beuty/core/widgets/loader.dart';
import 'package:africa_beuty/feature/auth/view_model/uploadservice_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SelectService extends ConsumerStatefulWidget {
  const SelectService({super.key});

  @override
  ConsumerState<SelectService> createState() => _SelectServiceState();
}

class _SelectServiceState extends ConsumerState<SelectService> {
  // Set to store selected service indices
  final List<String> _selectedServiceIds = [];

  @override 
  void initState() {
    super.initState();
    // Initialize any necessary data or state here

    Future.microtask(() {
      ref.read(getMajorServiceViewModelProvider.notifier).getMajorService();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFetching = ref.watch(getMajorServiceViewModelProvider)?.isLoading == true;
    final isUploading = ref.watch(uploadServiceViewModelProvider)?.isLoading == true;
    final isLoading = isFetching || isUploading;
    // define data loaded from get all major
    final allMajorServices = ref.watch(getMajorServiceViewModelProvider);

    return Scaffold(
      body: isLoading ? 

      const Loader()
      
      :
      
      allMajorServices?.when(
        data: (service) {
          if (service.isEmpty) {
            return const Center(
              child: Text('No services available'),
            );
          }

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                // Header: "Preferred Services"
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Preferred Services',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Spacing Header
                // SliverSpaceHeader(title: 'Services'),

                // GridView for Services
                SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: SliverGrid(
                    gridDelegate: SliverWovenGridDelegate.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 32,
                      crossAxisSpacing: 32,
                      pattern: [
                        WovenGridTile(1),
                        WovenGridTile(
                          6 / 6,
                          crossAxisRatio: 1,
                          alignment: AlignmentDirectional.centerEnd,
                        ),
                      ],
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        // Check if the current service is selected
                        final currentService = service[index];
                        final isSelected = _selectedServiceIds.contains(currentService.id);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              // Toggle selection
                              if (_selectedServiceIds.contains(currentService.id)) {
                                _selectedServiceIds.remove(currentService.id); // Deselect
                              } else {
                                _selectedServiceIds.add(currentService.id); // Select
                              }
                            });

                          },
                          
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.blue // Selected color
                                  : Colors.grey.shade200, // Unselected color
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: Stack(children: [ 
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(70),
                                  child: Image.network(
                                    currentService.fileName, 
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  bottom: 50,
                                  left: 40,
                                  child: Text(
                                    currentService.name,
                                    style: TextStyle(
                                      color: isSelected ? Colors.pink : Colors.orange,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: service.length, // Number of grid items
                    ),
                  ),
                ),

                // Finish Button
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton(
                      onPressed: isLoading ? null : () async {
                        if (_selectedServiceIds.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please select at least one service')),
                          );
                          return;
                        }

                        try {
                          await ref.read(uploadServiceViewModelProvider.notifier).uploadService(
                            selectedServices: _selectedServiceIds,
                          );
                          
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Successfully uploaded services')),
                          );
                            Navigator.pushReplacementNamed(context, '/page0');
                          }
                        } catch (e) {
                          if(mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error uploading services: $e')),
                            );
                          }
                        }

                      },
                      child: Text(
                        'Finish',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }, 
        error: (error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text('Failed to load services'),
                TextButton(
                  onPressed: () => ref.refresh(getMajorServiceViewModelProvider),
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        },

        loading: () {
          return null;
        },
      )
    );
  }
}