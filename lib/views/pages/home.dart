part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<Province> provinceData = [];
  List<Costs> selectedCost = [];
  TextEditingController weight = TextEditingController();

  bool isLoading = false;
  bool isEmpty = true;

  dynamic cityDataOrigin;
  dynamic cityIdOrigin;
  dynamic selectedCityOrigin;
  dynamic cityDataDestination;
  dynamic cityIdDestination;
  dynamic selectedCityDestination;
  dynamic selectedProvinceOrigin;
  dynamic selectedProvinceDestination;
  dynamic provinceData;
  dynamic selectedCourier;

  Future<List<Province>> getProvinces() async {
    ////
    dynamic temp;
    await MasterDataService.getProvince().then((value) {
      setState(() {
        temp = value;
        isLoading = false;
      });
    });
    return temp;
  }

  Future<List<City>> getCities(var provId) async {
    ////
    dynamic city;
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        city = value;
      });
    });

    return city;
  }

  Future<List<Costs>> getCosts(
      var originId, var destinationId, var weight, var courier) async {
    ////
    try {
      List<Costs> costs = await MasterDataService.getCosts(
          originId, destinationId, weight, courier);

      return costs;
    } catch (e) {
      print('Error $e');
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getProvinces(); ////
    provinceData = getProvinces();
    // cityDataOrigin = getCities("5");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Hitung Ongkir',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Flexible(
                flex: 4,
                child: Container(
                  margin: EdgeInsets.all(20),
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Courier
                          Expanded(
                            flex: 1,
                            child: DropdownButton(
                              isExpanded: true,
                              value: selectedCourier,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 30,
                              elevation: 4,
                              style: TextStyle(color: Colors.black),
                              hint: Text('Pilih kurir'),
                              items: [
                                DropdownMenuItem(
                                    value: 'jne', child: Text('jne')),
                                DropdownMenuItem(
                                    value: 'pos', child: Text('pos')),
                                DropdownMenuItem(
                                    value: 'tiki', child: Text('tiki')),
                              ],
                              onChanged: (newValue) {
                                setState(() {
                                  selectedCourier = newValue;
                                });
                              },
                            ),
                          ),
                          // Weight
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: weight,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'),
                                ),
                              ],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Berat (gr)',
                                labelStyle: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Origin',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      Row(
                        children: [
                          // Province Origin
                          Flexible(
                            flex: 1,
                            child: FutureBuilder<List<Province>>(
                                future: provinceData,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                        isExpanded: true,
                                        value: selectedProvinceOrigin,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: TextStyle(color: Colors.black),
                                        hint: selectedProvinceOrigin == null
                                            ? Text('Pilih provinsi')
                                            : Text(selectedProvinceOrigin
                                                .province),
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<Province>>(
                                                (Province value) {
                                          return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                  value.province.toString()));
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedProvinceOrigin = newValue;
                                            cityDataOrigin = getCities(
                                                selectedProvinceOrigin
                                                    .provinceId);
                                          });
                                        });
                                  } else if (snapshot.hasError) {
                                    return Text('Tidak ada data.');
                                  }
                                  return UiLoading.loadingSmall();
                                }),
                          ),
                          // City Origin
                          Flexible(
                            flex: 1,
                            child: FutureBuilder<List<City>>(
                                future: cityDataOrigin,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return UiLoading.loadingSmall();
                                  }

                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                        isExpanded: true,
                                        value: selectedCityOrigin,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: TextStyle(color: Colors.black),
                                        hint: selectedCityOrigin == null
                                            ? Text('Pilih kota')
                                            : Text(selectedCityOrigin.cityName),
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<City>>(
                                                (City value) {
                                          return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                  value.cityName.toString()));
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedCityOrigin = newValue;
                                            cityIdOrigin =
                                                selectedCityOrigin.cityId;
                                          });
                                        });
                                  } else if (snapshot.hasError) {
                                    return Text('Tidak ada data.');
                                  }
                                  return DropdownButton(
                                      isExpanded: true,
                                      value: selectedCityOrigin,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 4,
                                      style: TextStyle(color: Colors.black),
                                      items: [],
                                      onChanged: (value) {
                                        Null;
                                      },
                                      isDense: false,
                                      hint: Text('Pilih kota'),
                                      disabledHint: Text('Pilih kota'));
                                }),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          child: Text(
                            'Destination',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          // Provice Destination
                          Flexible(
                            flex: 1,
                            child: FutureBuilder<List<Province>>(
                                future: provinceData,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                        isExpanded: true,
                                        value: selectedProvinceDestination,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: TextStyle(color: Colors.black),
                                        hint: selectedProvinceDestination ==
                                                null
                                            ? Text('Pilih provinsi')
                                            : Text(selectedProvinceDestination
                                                .province),
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<Province>>(
                                                (Province value) {
                                          return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                  value.province.toString()));
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedProvinceDestination =
                                                newValue;
                                            cityDataDestination = getCities(
                                                selectedProvinceDestination
                                                    .provinceId);
                                          });
                                        });
                                  } else if (snapshot.hasError) {
                                    return Text('Tidak ada data.');
                                  }
                                  return UiLoading.loadingSmall();
                                }),
                          ),
                          // City Destination
                          Flexible(
                            flex: 1,
                            child: FutureBuilder<List<City>>(
                                future: cityDataDestination,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return UiLoading.loadingSmall();
                                  }

                                  if (snapshot.hasData) {
                                    return DropdownButton(
                                        isExpanded: true,
                                        value: selectedCityDestination,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: TextStyle(color: Colors.black),
                                        hint: selectedCityDestination == null
                                            ? Text('Pilih kota')
                                            : Text(selectedCityDestination
                                                .cityName),
                                        items: snapshot.data!
                                            .map<DropdownMenuItem<City>>(
                                                (City value) {
                                          return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                  value.cityName.toString()));
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedCityDestination = newValue;
                                            cityIdDestination =
                                                selectedCityDestination.cityId;
                                          });
                                        });
                                  } else if (snapshot.hasError) {
                                    return Text('Tidak ada data.');
                                  }
                                  return DropdownButton(
                                      isExpanded: true,
                                      value: selectedCityDestination,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      elevation: 4,
                                      style: TextStyle(color: Colors.black),
                                      items: [],
                                      onChanged: (value) {
                                        Null;
                                      },
                                      isDense: false,
                                      hint: Text("Pilih kota"),
                                      disabledHint: Text("Pilih kota"));
                                }),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            onPressed: () async {
                              if (weight.text.isEmpty ||
                                  selectedProvinceOrigin == null ||
                                  selectedProvinceDestination == null ||
                                  selectedCityOrigin == null ||
                                  selectedCityDestination == null ||
                                  selectedCourier == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Data kurang lengkap.'),
                                  ),
                                );
                                return;
                              }

                              setState(() {
                                isLoading = true;
                              });
                              selectedCost = await getCosts(
                                  selectedCityOrigin.cityId,
                                  selectedCityDestination.cityId,
                                  weight.text,
                                  selectedCourier);
                              setState(() {
                                isLoading = false;
                                isEmpty = false;
                              });
                            },
                            child: const Text('Hitung Estimasi Harga'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 5,
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: isEmpty != false
                        ? const Align(
                            alignment: Alignment.center,
                            child: Text('Tidak ada data.'),
                          )
                        : ListView.builder(
                            itemCount: selectedCost.length,
                            itemBuilder: (context, index) {
                              return CardCosts(selectedCost[index]);
                            })),
              ),
            ],
          ),
          isLoading == true ? UiLoading.loadingBlock() : Container()
        ],
      ),
    );
  }
}
