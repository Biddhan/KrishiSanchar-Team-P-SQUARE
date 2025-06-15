import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p_square/app/features/plant/controller/plant_controller.dart';

import '../models/user_model.dart';
import 'widgets/jagga_tab.dart';

class PlantView extends StatefulWidget {
  const PlantView({super.key});

  @override
  State<PlantView> createState() => _PlantViewState();
}

class _PlantViewState extends State<PlantView>
    with SingleTickerProviderStateMixin {
  final controller = Get.find<PlantController>();

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Tab Bar
          TabBar(
            controller: tabController,
            tabs: [
              Tab(text: "बिरुवा"),
              Tab(text: "आना"),
            ],
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.green,
          ),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildPlantDetectionSection(),

                      Obx(
                        () => controller.predictionResult.value != null
                            ? _buildResultsSection()
                            : const SizedBox.shrink(),
                      ),

                      // Recommended Products Section
                      Obx(
                        () => controller.recommendedProducts.isNotEmpty
                            ? _buildRecommendedProductsSection()
                            : const SizedBox.shrink(),
                      ),

                      Obx(
                        () => controller.predictionResult.value != null
                            ? _buildExpertsSection()
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),

                const JaggaTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantDetectionSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "बिरुवा रोग पहिचान",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          _buildPlantTypeSelector(),
          const SizedBox(height: 16),

          _buildImagePreview(),
          const SizedBox(height: 16),

          _buildImageSelectionButtons(),
          const SizedBox(height: 16),

          _buildPredictButton(),
        ],
      ),
    );
  }

  Widget _buildPlantTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "बिरुवाको प्रकार छान्नुहोस्:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: controller.plantTypes
              .map((type) => _buildPlantTypeButton(type))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildPlantTypeButton(String type) {
    return Obx(
      () => OutlinedButton(
        onPressed: () => controller.changePlantType(type),
        style: OutlinedButton.styleFrom(
          backgroundColor: controller.selectedPlantType.value == type
              ? Colors.green.withValues(alpha: 0.2)
              : Colors.transparent,
          side: BorderSide(
            color: controller.selectedPlantType.value == type
                ? Colors.green
                : Colors.grey,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Text(
            _getPlantTypeNepaliName(type),
            style: TextStyle(
              color: controller.selectedPlantType.value == type
                  ? Colors.green
                  : Colors.grey[700],
              fontWeight: controller.selectedPlantType.value == type
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  String _getPlantTypeNepaliName(String type) {
    switch (type) {
      case "Tomato":
        return "टमाटर";
      case "Potato":
        return "आलु";
      case "Maize":
        return "मकै";
      default:
        return type;
    }
  }

  Widget _buildImagePreview() {
    return Obx(
      () => Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[400]!),
        ),
        child: controller.selectedImage.value != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      controller.selectedImage.value!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: controller.clearImage,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 48,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "बिरुवाको तस्बिर छान्नुहोस्",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildImageSelectionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: controller.pickImageFromCamera,
            icon: const Icon(Icons.camera_alt),
            label: const Text("क्यामेरा"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: controller.pickImageFromGallery,
            icon: const Icon(Icons.photo_library),
            label: const Text("ग्यालेरी"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPredictButton() {
    return Obx(
      () => ElevatedButton(
        onPressed:
            controller.isLoading.value || controller.selectedImage.value == null
            ? null
            : controller.predictPlantDisease,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: controller.isLoading.value
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                "रोग पहिचान गर्नुहोस्",
                style: TextStyle(fontSize: 16),
              ),
      ),
    );
  }

  Widget _buildResultsSection() {
    final result = controller.predictionResult.value!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.medical_information,
                color: Colors.green,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                "पहिचान परिणाम - ${controller.getPlantTypeNepaliName()}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 24),

          // Disease name and confidence
          Column(
            children: [
              _buildResultItem(
                "रोगको नाम",
                controller.formatDiseaseName(result.predictedClass),
                Icons.bug_report,
              ),
              const SizedBox(height: 16),
              _buildResultItem(
                "विश्वासनीयता",
                "${result.confidence.toStringAsFixed(2)}%",
                Icons.verified,
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (result.recommendation.disease.isNotEmpty)
            _buildExpandableSection(
              "रोगको विवरण",
              result.recommendation.disease,
              Icons.info_outline,
            ),

          if (result.recommendation.causes.isNotEmpty)
            _buildExpandableSection(
              "कारणहरू",
              result.recommendation.causes,
              Icons.warning_amber,
            ),

          if (result.recommendation.symptoms.isNotEmpty)
            _buildExpandableSection(
              "लक्षणहरू",
              result.recommendation.symptoms,
              Icons.sick,
            ),

          if (result.recommendation.management.isNotEmpty)
            _buildExpandableSection(
              "व्यवस्थापन",
              result.recommendation.management,
              Icons.healing,
            ),
        ],
      ),
    );
  }

  Widget _buildRecommendedProductsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shopping_bag, color: Colors.green, size: 24),
              const SizedBox(width: 8),
              const Text(
                "सिफारिस गरिएका उत्पादनहरू",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(height: 24),

          Obx(() {
            if (controller.isLoadingRecommendedProducts.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (controller.recommendedProducts.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "कुनै सिफारिस गरिएका उत्पादनहरू फेला परेनन्",
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            } else {
              return _buildProductGrid(controller.recommendedProducts);
            }
          }),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<dynamic> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildExpertsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person, color: Colors.green, size: 24),
              const SizedBox(width: 8),
              const Text(
                "विशेषज्ञहरू",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(height: 24),

          Obx(() {
            if (controller.isLoadingExperts.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (controller.experts.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "कुनै विशेषज्ञ फेला परेन",
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.experts.length,
                itemBuilder: (context, index) {
                  final expert = controller.experts[index];
                  return _buildExpertCard(expert);
                },
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _buildExpertCard(User expert) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green.shade100,
                  child: Text(
                    expert.fullName.substring(0, 1),
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expert.fullName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        expert.email,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildExpertInfoRow(Icons.phone, "फोन", expert.phoneNumber),
            const SizedBox(height: 8),
            _buildExpertInfoRow(Icons.location_on, "ठेगाना", expert.address),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _contactExpert(expert),
                icon: const Icon(Icons.message),
                label: const Text("सम्पर्क गर्नुहोस्"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpertInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  void _contactExpert(User expert) {}

  Widget _buildProductCard(dynamic product) {
    return InkWell(
      onTap: () => controller.navigateToProductDetail(product),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(product.imageUrl),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) =>
                        const AssetImage('assets/images/placeholder.png'),
                  ),
                ),
              ),
            ),

            // Product Details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Price
                  Text(
                    "रु. ${product.unitPrice.toString()}",
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),

                  // Stock Status
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: product.stock > 0 ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      product.stock > 0 ? "स्टकमा छ" : "स्टकमा छैन",
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.green),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableSection(
    String title,
    List<String> items,
    IconData icon,
  ) {
    return ExpansionTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                item,
                style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                textAlign: TextAlign.justify,
              ),
            ),
          )
          .toList(),
    );
  }
}
