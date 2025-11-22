import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _allowanceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _allowanceController.dispose();
    super.dispose();
  }

  void handleNext() {
    if (currentSlide < 4) {
      setState(() {
        currentSlide++;
      });
    }
  }

  void handleFinish() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF5E6D3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: Color(0xFF6B4423),
            width: 3,
          ),
        ),
        title: const Text(
          'Confirm Your Choices',
          style: TextStyle(
            fontFamily: 'Questrial',
            color: Color(0xFF6B4423),
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'Are you sure of your pet choice and pet name? They cannot be changed until you further progress in game.',
          style: TextStyle(
            fontFamily: 'Questrial',
            color: Color(0xFF6B4423),
            fontSize: 16,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Questrial',
                color: Color(0xFF8B6443),
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to dashboard or next screen
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => const DashboardScreen()),
              // );
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
        actionsAlignment: MainAxisAlignment.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8C5B5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: _buildSlideContent(),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: currentSlide == 4 ? handleFinish : handleNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B4423),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 100,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 8,
                      shadowColor: Colors.black.withOpacity(0.3),
                    ),
                    child: Text(
                      currentSlide == 4 ? 'Finish' : 'Next',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Questrial',
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () => setState(() => currentSlide = index),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == currentSlide
                                ? const Color(0xFF6B4423)
                                : Colors.transparent,
                            border: Border.all(
                              color: const Color(0xFF6B4423),
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    }),
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
        return _buildChoosePetSlide();
      case 3:
        return _buildNamePetSlide();
      case 4:
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
        const SizedBox(height: 10),
        Image.asset(
          'assets/images/logo.png',
          width: 275,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'A tool that gamifies your budgeting journey. The more you save, the better your pet will be.',
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Text(
            'Checklist',
            style: TextStyle(
              fontSize: 38,
              color: Color(0xFF6B4423),
              fontFamily: 'Questrial',
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          _buildChecklistItem(
            'Step 1:',
            'Choose Your Pet',
            'You start with one but you can collect more by completing missions.',
            'assets/images/dog_egg.png',
          ),
          const SizedBox(height: 60),
          _buildChecklistItem(
            'Step 2:',
            'Set Your Budget',
            'This will affect your missions and budgeting suggestions. You can update this later in settings.',
            'assets/images/dog.png',
          ),
        ],
      ),
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
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 16),
            Image.asset(imagePath, width: 100, height: 100),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
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
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        _buildPetOption(
          'dog',
          'Dog',
          'Playful, outgoing, super friendly. Everyone\'s best friend and always down for an adventure.',
          'assets/images/dog.png',
        ),
        const SizedBox(height: 10 ),
        _buildPetOption(
          'cat',
          'Cat',
          'Sophisticated, nonchalant, a bit introverted, loves books and quiet nights',
          'assets/images/cat.png',
        ),
      ],
    );
  }

  Widget _buildPetOption(
      String petType, String name, String description, String imagePath) {
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
            ),
            child: Image.asset(imagePath, width: 125, height: 125),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: const TextStyle(
              fontSize: 26,
              color: Color(0xFF6B4423),
              fontFamily: 'Questrial',
            ),
          ),
          const SizedBox(height: 5),
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
            fontWeight: FontWeight.w400,
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
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 60),
        _buildDropdownField(),
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

  Widget _buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF6B4423), width: 4),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
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
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: userType,
                    isExpanded: true,
                    icon: const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF6B4423),
                        size: 28,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFFA0A0A0),
                      fontFamily: 'Questrial',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Student/Employee',
                        child: Text('Student/Employee'),
                      ),
                      DropdownMenuItem(
                        value: 'Freelancer',
                        child: Text('Freelancer'),
                      ),
                      DropdownMenuItem(
                        value: 'Business Owner',
                        child: Text('Business Owner'),
                      ),
                      DropdownMenuItem(
                        value: 'Other',
                        child: Text('Other'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => userType = value);
                      }
                    },
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
              color: Colors.black.withOpacity(0.15),
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
                  Icons.account_circle,
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