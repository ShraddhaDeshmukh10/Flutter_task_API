import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SongPageDesign extends StatefulWidget {
  @override
  _SongPageDesignState createState() => _SongPageDesignState();
}

class _SongPageDesignState extends State<SongPageDesign> {
  List<Map<String, String>> _imageData = [];
  int _currentIndex = 0;
  List<Map<String, String>> _imageFav = [];
  List<Map<String, String>> _mythologyData = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
    _loadFavImages();
    _loadMythology();
  }

  Future<void> _loadMythology() async {
    final String response = await rootBundle.loadString('assets/indian.json');
    final data = jsonDecode(response) as List<dynamic>;
    setState(() {
      _mythologyData = data.map((item) {
        return {
          'image_url': item['image_url01'] as String,
          'name': item['name01'] as String,
        };
      }).toList();
    });
  }

  Future<void> _loadFavImages() async {
    final String response = await rootBundle.loadString('assets/favrites.json');
    final data = jsonDecode(response) as List<dynamic>;
    setState(() {
      _imageFav = data.map((item) {
        return {
          'image_url': item['image_url'] as String,
          'name': item['name'] as String,
        };
      }).toList();
    });
  }

  Future<void> _loadImages() async {
    final String response = await rootBundle.loadString('assets/image.json');
    final data = jsonDecode(response) as List<dynamic>;
    setState(() {
      _imageData = data.map((item) {
        return {
          'image_url': item['image_url'] as String,
          'name': item['name'] as String,
        };
      }).toList();
    });
  }

  Widget _buildImageCard(Map<String, String> item) {
    return Container(
      width: 150,
      height: 150,
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Stack(
        children: [
          Container(
            width: 150,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: NetworkImage(item['image_url']!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 45,
            child: SvgPicture.asset(
              "assets/ic_play.svg",
              width: 50,
              height: 60,
            ),
          ),
          Positioned(
            bottom: 30,
            left: 35,
            child: Text(
              item['name']!,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/home-header.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 10,
                        left: 20,
                        child: SvgPicture.asset(
                          "assets/star_premium.svg",
                          width: 80,
                          height: 100,
                        ),
                      ),
                      Positioned(
                        top: 50,
                        left: -14,
                        child: Image.asset("assets/story-top-cloud.png"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                _imageData.isNotEmpty
                    ? Column(
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 200,
                              autoPlay: true,
                              aspectRatio: 16 / 9,
                              viewportFraction: 0.8,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                            ),
                            items: _imageData.map((item) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                        image: NetworkImage(item['image_url']!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 10,
                                          left: 10,
                                          child: Text(
                                            item['name']!,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 40,
                                          left: 20,
                                          child: SvgPicture.asset(
                                            "assets/ic_play.svg",
                                            width: 50,
                                            height: 80,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _imageData.asMap().entries.map((entry) {
                              int index = entry.key;
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentIndex == index
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      )
                    : Center(child: CircularProgressIndicator()),
                SizedBox(height: 20),
                _buildSectionTitle(Icons.favorite_rounded, "Favorites"),
                SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _imageFav.length,
                    itemBuilder: (context, index) {
                      return _buildImageCard(_imageFav[index]);
                    },
                  ),
                ),
                Container(
                    child: Row(
                  children: [
                    SizedBox(width: 20),
                    Image.asset(
                      "assets/Gramdma.png",
                      height: 50,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Everyday Stories",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                )),
                SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _imageData.length,
                    itemBuilder: (context, index) {
                      return _buildImageCard(_imageData[index]);
                    },
                  ),
                ),
                _buildSectionTitle(Icons.star, "Mythology"),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _mythologyData.length,
                    itemBuilder: (context, index) {
                      return _buildImageCard(_mythologyData[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Container(
      child: Row(
        children: [
          SizedBox(width: 30),
          Icon(icon, color: Colors.red, size: 40),
          SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
