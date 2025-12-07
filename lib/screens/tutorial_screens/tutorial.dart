import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // ✅ Added Supabase
import '../../pages/dashboard/dashboard.dart'; // ✅ Fixed dashboard import

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  int currentSlide = 0;
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

            // FORCE POPUP WIDTH
            content: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo.png',
                    height: 70,
                  ),

                  const SizedBox(height: 15),

                  // Title
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

                  // Message
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

                  // OK Button
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

const int petNameMaxLength = 12;

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

    if (petName.trim().length > petNameMaxLength) {
      showStyledPopup(
        context: context,
        title: "Name Too Long",
        message:
            "Your pet's name is too long. Please limit it to $petNameMaxLength characters.",
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
        message:
            "Please enter a display name before continuing.",
      );
      return;
    }

  }

  // Continue to next slide
  if (currentSlide < 5) {
    setState(() {
      currentSlide++;
    });
  }
}


  Future<void> handleFinish() async {

    const int displayNameMaxLength = 12;

      if (displayName.trim().length > displayNameMaxLength) {
      showStyledPopup(
        context: context,
        title: "Name Too Long",
        message:
            "Your display name is too long. Please limit it to $displayNameMaxLength characters.",
      );
      return;
    }

            if (displayName.trim().isEmpty) {
          showStyledPopup(
  context: context,
  title: "Display Name Empty",
  message: "Please enter your display name.",
);
          return;
        }

        if (monthlyAllowance.trim().isEmpty) {
          showStyledPopup(
  context: context,
  title: "Monthly Allowance Empty",
  message: "Please enter your monthly allowance.",
);

if (monthlyAllowance.trim().isEmpty) {
  showStyledPopup(
    context: context,
    title: "Monthly Allowance Empty",
    message: "Please enter your monthly allowance.",
  );
  return;
}

// Check if the input contains only numbers (and optional decimal point)
if (!RegExp(r'^\d+\.?\d*$').hasMatch(monthlyAllowance.trim())) {
  showStyledPopup(
    context: context,
    title: "Invalid Input",
    message: "Please enter a valid number for your monthly allowance.",
  );
  return;
}

// Optional: Check if the value is greater than 0
double? allowanceValue = double.tryParse(monthlyAllowance.trim());
if (allowanceValue == null || allowanceValue <= 0) {
  showStyledPopup(
    context: context,
    title: "Invalid Amount",
    message: "Please enter an amount greater than 0.",
  );
  return;
}
          return;
        }
showDialog(
  context: context,
  builder: (context) => LayoutBuilder(
    builder: (context, constraints) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: constraints.maxWidth * 0.9, // Make popup wide
          minWidth: constraints.maxWidth * 0.9,
        ),
        child: AlertDialog(
          backgroundColor: const Color(0xFFF5E6D3),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF6B4423), width: 3),
          ),

          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ⭐ LOGO ON TOP
              Image.asset(
                "assets/images/logo.png",
                height: 80,
              ),
              const SizedBox(height: 10),

              // ⭐ TITLE
              const Text(
                'Confirm Your Choices',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Questrial',
                  color: Color(0xFF6B4423),
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),

              // ⭐ MESSAGE
              const Text(
                'Are you sure of your pet choice and pet name? They cannot be changed until you further progress in game.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Questrial',
                  color: Color(0xFF6B4423),
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),

          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 15),

          actions: [
            // ❌ CANCEL (outlined)
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5E6D3),
                foregroundColor: const Color(0xFF6B4423),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: const BorderSide(color: Color(0xFF6B4423), width: 2),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Questrial',
                  fontSize: 16,
                ),
              ),
            ),

            // ✅ CONFIRM (solid brown)
            ElevatedButton(
              onPressed: () async {
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
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B4423),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(
                  fontFamily: 'Questrial',
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      );
    },
  ),
);
  }

  // Replace the existing build method's button section with this:

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
                // Progress dots on top
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == currentSlide
                            ? const Color(0xFF6B4423)
                            : Colors.transparent,
                        border: Border.all(color: const Color(0xFF6B4423), width: 2),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 28),
                // Back and Next buttons row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Back button (only show if not on first slide)
                    if (currentSlide > 0)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentSlide--;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF5E6D3),
                          foregroundColor: const Color(0xFF6B4423),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: const BorderSide(
                              color: Color(0xFF6B4423),
                              width: 3,
                            ),
                          ),
                          elevation: 8,
                          shadowColor: Colors.black.withAlpha(77),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_back, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Back',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Questrial',
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    // Spacer between buttons
                    if (currentSlide > 0) const SizedBox(width: 20),
                    
                    // Next/Finish button
                    ElevatedButton(
                      onPressed: currentSlide == 5 ? handleFinish : handleNext,
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
                            currentSlide == 5 ? 'Finish' : 'Next',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Questrial',
                            ),
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

  Widget _buildSlideContent() {
    switch (currentSlide) {
      case 0:
        return _buildWelcomeSlide();
      case 1:
        return _buildChecklistSlide();
      case 2:
        return _buildChecklist2Slide();
      case 3:
        return _buildChoosePetSlide();
      case 4:
        return _buildNamePetSlide();
      case 5:
        return _buildAllowanceSlide();
      default:
        return Container();
    }
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
      
      final titleSpacing = isLargeScreen ? 40.0 : screenHeight * 0.08;
      final itemSpacing = isLargeScreen ? 60.0 : screenHeight * 0.06;
      
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
                'Your brand new budget accountability buddy! Choose wisely as this pet will accompany you on your budgeting journey.',
                'assets/images/dog_egg.png',
              ),
            ),
            SizedBox(height: itemSpacing),
            Flexible(
              child: _buildChecklistItem(
                'Step 2:',
                'Set Your Budget',
                'Your allowance will determine how much you can spend each month. We will help you keep track!',
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
      
      final titleSpacing = isLargeScreen ? 40.0 : screenHeight * 0.08;
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
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6B4423),
                  fontFamily: 'Questrial',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 20),
            Image.asset(imagePath, width: 100, height: 100),
            const SizedBox(width: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color(0xFF6B4423),
                    fontFamily: 'Questrial',
                    height: 1.5,
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
        const SizedBox(height: 30),
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
            child: Image.asset(imagePath, width: 125, height: 125),
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
          const SizedBox(height: 5),
          // ✅ Pet description - easily customizable
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 17,
                color: Color(0xFF6B4423),
                fontFamily: 'Questrial',
                height: 1.5,
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
                  keyboardType: TextInputType.number,
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