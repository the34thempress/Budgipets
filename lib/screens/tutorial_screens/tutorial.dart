import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../pages/dashboard/dashboard.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key}); // use super.key

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  int currentSlideIndex = 0;
  List<int> availableSlides = [];

  String userType = 'Student/Employee';
  String monthlyAllowance = '';
  String selectedPet = '';
  String petName = '';
  String displayName = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _allowanceController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _allowanceController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadSlides();
  }

  Future<void> _loadSlides() async {
    final prefs = await SharedPreferences.getInstance();

    // Always include checklist slides
    availableSlides = [1, 2];

    // Only include slides if values not yet set
    if ((prefs.getString('selected_pet') ?? '').isEmpty) availableSlides.add(3);
    if ((prefs.getString('pet_name') ?? '').isEmpty) availableSlides.add(4);
    if ((prefs.getString('display_name') ?? '').isEmpty ||
        (prefs.getString('monthly_allowance') ?? '').isEmpty) availableSlides.add(5);

    // Pre-fill existing values
    selectedPet = prefs.getString('selected_pet') ?? '';
    petName = prefs.getString('pet_name') ?? '';
    displayName = prefs.getString('display_name') ?? '';
    monthlyAllowance = prefs.getString('monthly_allowance') ?? '';

    _nameController.text = petName;
    _displayNameController.text = displayName;
    _allowanceController.text = monthlyAllowance;

    setState(() {
      currentSlideIndex = 0;
    });
  }

  Future<void> showStyledPopup({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    return showDialog(
      context: context,
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = (constraints.maxWidth * 0.9).clamp(0, 500.0) as double;

            return AlertDialog(
              backgroundColor: const Color(0xFFFDE6D0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFF6B4423), width: 3),
              ),
              contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              content: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 70,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Questrial',
                        color: Color(0xFF6B4423),
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Questrial',
                        color: Color(0xFF6B4423),
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B4423),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'OK',
                          style: TextStyle(
                            fontFamily: 'Questrial',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void handleNext() {
    final currentSlide = availableSlides[currentSlideIndex];

    // Slide 3 → Pet selection check
    if (currentSlide == 3 && selectedPet.isEmpty) {
      showStyledPopup(
        context: context,
        title: "Pet Not Selected",
        message: "Please choose a pet before continuing.",
      );
      return;
    }

    // Slide 4 → Pet name validation
    if (currentSlide == 4) {
      if (petName.trim().isEmpty) {
        showStyledPopup(
          context: context,
          title: "Pet Name Empty",
          message: "Please enter a name for your pet before continuing.",
        );
        return;
      }
      if (petName.trim().length > 12) {
        showStyledPopup(
          context: context,
          title: "Name Too Long",
          message: "Your pet's name is too long. Please limit it to 12 characters.",
        );
        return;
      }
    }

    // Slide 5 → Display name validation
    if (currentSlide == 5) {
      if (displayName.trim().isEmpty) {
        showStyledPopup(
          context: context,
          title: "Display Name Empty",
          message: "Please enter a display name before continuing.",
        );
        return;
      }
    }

    // Continue to next slide
    if (currentSlideIndex < availableSlides.length - 1) {
      setState(() {
        currentSlideIndex++;
      });
    }
  }

  void handleBack() {
    if (currentSlideIndex > 0) {
      setState(() => currentSlideIndex--);
    }
  }

  Future<void> handleFinish() async {
  // Only run slide 5 validations if the slide exists in this session
  if (availableSlides.contains(5)) {
    if (displayName.trim().isEmpty) {
      await showStyledPopup(
        context: context,
        title: "Display Name Empty",
        message: "Please enter a display name before continuing.",
      );
      return;
    }
    if (displayName.trim().length > 12) {
      await showStyledPopup(
        context: context,
        title: "Display Name Too Long",
        message: "Display name must be 12 characters or less.",
      );
      return;
    }
    if (RegExp(r'^[0-9]+$').hasMatch(displayName.trim())) {
      await showStyledPopup(
        context: context,
        title: "Invalid Display Name",
        message: "Display name cannot contain only numbers. Please include letters.",
      );
      return;
    }
    if (monthlyAllowance.trim().isEmpty) {
      await showStyledPopup(
        context: context,
        title: "Allowance Empty",
        message: "Please enter your monthly allowance before continuing.",
      );
      return;
    }
    final allowanceNum = double.tryParse(monthlyAllowance.trim());
    if (allowanceNum == null || allowanceNum <= 0) {
      await showStyledPopup(
        context: context,
        title: "Invalid Allowance",
        message: "Please enter a valid positive number for your monthly allowance.",
      );
      return;
    }
  }

  // Save data regardless of slides
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('tutorial_completed', true);
  if (selectedPet.isNotEmpty) await prefs.setString('selected_pet', selectedPet);
  if (petName.isNotEmpty) await prefs.setString('pet_name', petName);
  if (displayName.isNotEmpty) await prefs.setString('display_name', displayName);
  await prefs.setString('user_type', userType);
  if (monthlyAllowance.isNotEmpty) {
    await prefs.setString('monthly_allowance', monthlyAllowance);
  }

  try {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      await Supabase.instance.client
          .from('users')
          .update({'tutorial_completed': true})
          .eq('id', user.id);
    }
  } catch (e) {
    debugPrint('Error updating Supabase tutorial_completed: $e');
  }

  if (!context.mounted) return;

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const DashboardPage()),
  );
}


  Widget _buildSlideContent() {
    if (availableSlides.isEmpty) return Container();

    final slide = availableSlides[currentSlideIndex];
    switch (slide) {
      case 0: return _buildWelcomeSlide();
      case 1: return _buildChecklistSlide();
      case 2: return _buildChecklist2Slide();
      case 3: return _buildChoosePetSlide();
      case 4: return _buildNamePetSlide();
      case 5: return _buildAllowanceSlide();
      default: return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFADEC6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(child: _buildSlideContent()),
                ),
              ),
              const SizedBox(height: 40),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      availableSlides.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == currentSlideIndex
                              ? const Color(0xFF6B4423)
                              : Colors.transparent,
                          border: Border.all(color: const Color(0xFF6B4423), width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (currentSlideIndex > 0)
                        ElevatedButton(
                          onPressed: handleBack,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF5E6D3),
                            foregroundColor: const Color(0xFF6B4423),
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: const BorderSide(color: Color(0xFF6B4423), width: 3),
                            ),
                            elevation: 8,
                            shadowColor: Colors.black.withAlpha(77),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_back, size: 24),
                              SizedBox(width: 8),
                              Text('Back', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, fontFamily: 'Questrial')),
                            ],
                          ),
                        ),
                      if (currentSlideIndex > 0) const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: currentSlideIndex == availableSlides.length - 1 
                              ? handleFinish
                              : handleNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6B4423),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            elevation: 8,
                            shadowColor: Colors.black.withAlpha(77),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                currentSlideIndex == availableSlides.length - 1 ? 'Finish' : 'Next',
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Questrial'),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 24),
                            ],
                          ),
                        ),

                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildWelcomeSlide() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Welcome Budgeteer!',
          style: TextStyle(
            fontSize: 28,
            color: Color(0xFF6B4423),
            fontFamily: 'Questrial',
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 1.5,
              color: const Color(0xFF6B4423),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'TO',
                style: TextStyle(
                  fontSize: 32,
                  color: Color(0xFF6B4423),
                  fontFamily: 'Questrial',
                ),
              ),
            ),
            Container(
              width: 100,
              height: 1.5,
              color: const Color(0xFF6B4423),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Image.asset(
          'assets/images/logo.png',
          width: 275,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'A tool that gamifies your budgeting journey.',
            style: TextStyle(
              fontSize: 19,
              color: Color(0xFF6B4423),
              fontFamily: 'Questrial',
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

Widget _buildChecklistSlide() {
  return LayoutBuilder(
    builder: (context, constraints) {
      final screenHeight = constraints.maxHeight;
      final isLargeScreen = screenHeight > 700;
      
      final titleSpacing = isLargeScreen ? 35.0 : screenHeight * 0.08;
      final itemSpacing = isLargeScreen ? 40.0 : screenHeight * 0.06;
      
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Checklist',
              style: TextStyle(
                fontSize: isLargeScreen ? 38 : screenHeight * 0.05,
                color: const Color(0xFF6B4423),
                fontFamily: 'Questrial',
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: titleSpacing),
            Flexible(
              child: _buildChecklistItem(
                'Step 1:',
                'Choose Your Pet',
                'Select and name a pet companion that will join you on your budgeting adventure!',
                'assets/images/dog_egg.png',
              ),
            ),
            SizedBox(height: itemSpacing),
            Flexible(
              child: _buildChecklistItem(
                'Step 2:',
                'Set Your Budget',
                'With your monthly allowance set, you can start logging your expenses and incomes to keep track of your budget!',
                'assets/images/puppy.png',
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildChecklist2Slide() {
  return LayoutBuilder(
    builder: (context, constraints) {
      final screenHeight = constraints.maxHeight;
      final isLargeScreen = screenHeight > 700;
      
      final titleSpacing = isLargeScreen ? 35.0 : screenHeight * 0.08;
      final itemSpacing = isLargeScreen ? 40.0 : screenHeight * 0.06;
      
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Checklist',
              style: TextStyle(
                fontSize: isLargeScreen ? 38 : screenHeight * 0.05,
                color: const Color(0xFF6B4423),
                fontFamily: 'Questrial',
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: titleSpacing),
            Flexible(
              child: _buildChecklistItem(
                'Step 3:',
                'Log Your Transactions',
                'Make sure you log all your expenses or incomes every day! You will get currency and evolution tokens for your pet!',
                'assets/images/coin.png',
              ),
            ),
            SizedBox(height: itemSpacing),
            Flexible(
              child: _buildChecklistItem(
                'Step 4:',
                'Go Shopping!',
                'Buy accessories to dress up your pet and make them unique to you! Show off your style as you budget better!',
                'assets/images/bow.png',
              ),
            ),
          ],
        ),
      );
    },
  );
}

  Widget _buildChecklistItem(
      String step, String title, String description, String imagePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5E6D3),
                border: Border.all(color: const Color(0xFF6B4423), width: 4),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                step,
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Questrial',
                  color: Color(0xFF6B4423),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B4423),
                  fontFamily: 'Questrial',
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 20),
            Image.asset(imagePath, width: 100, height: 107),
            const SizedBox(width: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color(0xFF6B4423),
                    fontFamily: 'Questrial',
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChoosePetSlide() {
    return Column(
      children: [
        const Text(
          'Choose Your Pet',
          style: TextStyle(
            fontSize: 32,
            color: Color(0xFF6B4423),
            fontFamily: 'Questrial',
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        _buildPetOption(
          petType: 'dog',
          name: 'Dog',
          description: 'Energetic, loyal, outgoing, loves \nadventures and playtime',
          imagePath: 'assets/images/dog.png',
        ),
        const SizedBox(height: 20),
        _buildPetOption(
          petType: 'cat',
          name: 'Cat',
          description: 'Independent, curious, affectionate, \nenjoys lounging and exploring',
          imagePath: 'assets/images/cat.png',
        ),
      ],
    );
  }

  Widget _buildPetOption({
    required String petType,
    required String name,
    required String description,
    required String imagePath,
  }) {
    bool isSelected = selectedPet == petType;
    return GestureDetector(
      onTap: () => setState(() => selectedPet = petType),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFF5E6D3),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF6B4423)
                    : const Color(0xFF8B6443),
                width: 4,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: const Color(0xFF6B4423).withAlpha(102),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: 2,
                ),
              ] : null,
            ),
            child: Image.asset(imagePath, width: 115, height: 115),
          ),
          const SizedBox(height: 5),
          // ✅ Pet name - easily customizable
          Text(
            name,
            style: TextStyle(
              fontSize: 27,
              color: const Color(0xFF6B4423),
              fontFamily: 'Questrial',
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          // ✅ Pet description - easily customizable
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF6B4423),
                fontFamily: 'Questrial',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNamePetSlide() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Give Your Pet A Name',
          style: TextStyle(
            fontSize: 38,
            color: Color(0xFF6B4423),
            fontFamily: 'Questrial',
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 60),
        Image.asset(
          selectedPet == 'cat'
              ? 'assets/images/cat.png'
              : 'assets/images/dog.png',
          width: 220,
          height: 220,
        ),
        const SizedBox(height: 60),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: TextField(
            controller: _nameController,
            onChanged: (value) {
              final filtered = value.replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), '');
              if (value != filtered) {
                _nameController.value = TextEditingValue(
                  text: filtered,
                  selection: TextSelection.collapsed(offset: filtered.length),
                );
              }
              setState(() {
                petName = filtered;
              });
            },
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF6B4423),
              fontFamily: 'Questrial',
            ),
            decoration: InputDecoration(
              hintText: 'Enter your pet\'s name...',
              hintStyle: const TextStyle(
                color: Color(0xFFA0A0A0),
                fontFamily: 'Questrial',
              ),
              filled: true,
              fillColor: const Color(0xFFF5E6D3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(
                  color: Color(0xFF6B4423),
                  width: 4,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(
                  color: Color(0xFF6B4423),
                  width: 4,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(
                  color: Color(0xFF6B4423),
                  width: 4,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 20,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Note: cannot accept special characters.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF7A7A7A),
            fontFamily: 'Questrial',
          ),
        ),
      ],
    );
  }

  Widget _buildAllowanceSlide() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Set your Allowance',
          style: TextStyle(
            fontSize: 38,
            color: Color(0xFF6B4423),
            fontFamily: 'Questrial',
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 60),
        _buildDisplayNameField(),
        const SizedBox(height: 40),
        _buildAllowanceField(),
        const SizedBox(height: 50),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'The following data can be changed in the settings page.',
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF6B4423),
              fontFamily: 'Questrial',
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildDisplayNameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF6B4423), width: 4),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(38), // 15% opacity
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFF6B4423),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFFF5E6D3),
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _displayNameController,
                  onChanged: (value) => setState(() => displayName = value),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF6B4423),
                    fontFamily: 'Questrial',
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Display Name',
                    hintStyle: TextStyle(
                      color: Color(0xFFA0A0A0),
                      fontFamily: 'Questrial',
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllowanceField() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 40),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF6B4423), width: 4),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(38),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFF6B4423),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                color: Color(0xFFF5E6D3),
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _allowanceController,
                onChanged: (value) => setState(() => monthlyAllowance = value),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                // ✅ Add input formatters to restrict to numbers and decimal point only
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF6B4423),
                  fontFamily: 'Questrial',
                ),
                decoration: const InputDecoration(
                  hintText: 'Monthly Allowance',
                  hintStyle: TextStyle(
                    color: Color(0xFFA0A0A0),
                    fontFamily: 'Questrial',
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}