import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/constants.dart';
import 'package:holdwise/app/cubits/auth_cubit/auth_cubit.dart';
import 'package:holdwise/common/widgets/role_based_appbar.dart';
import 'package:holdwise/common/widgets/role_based_side_navbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final role = context.read<AuthCubit>().state is AuthAuthenticated
        ? (context.read<AuthCubit>().state as AuthAuthenticated).role
        : AppRoles.patient;

    final user = context.read<AuthCubit>().state is AuthAuthenticated
        ? (context.read<AuthCubit>().state as AuthAuthenticated).user
        : null;
    
    return Scaffold(
      appBar: RoleBasedAppBar(title: '${user?.displayName}', displayActions: false,),
      body: Center(
        // user profile details
        child: role == AppRoles.patient
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Name: ${user?.displayName}'),
                  Text('Email: ${user?.email}'),
                  Text('Role: $role'),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Name: ${user?.displayName}'),
                  Text('Email: ${user?.email}'),
                  Text('Role: $role'),
                ],
        ),
      ),
    );
  }
}

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final role = context.read<AuthCubit>().state is AuthAuthenticated
        ? (context.read<AuthCubit>().state as AuthAuthenticated).role
        : AppRoles.patient;

    final user = context.read<AuthCubit>().state is AuthAuthenticated
        ? (context.read<AuthCubit>().state as AuthAuthenticated).user
        : null;
    
    return Scaffold(
      appBar: RoleBasedAppBar(title: '${user?.displayName}', displayActions: false,),
      body: Center(
        // user profile details
        child: role == AppRoles.patient
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Name: ${user?.displayName}'),
                  Text('Email: ${user?.email}'),
                  Text('Role: $role'),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Name: ${user?.displayName}'),
                  Text('Email: ${user?.email}'),
                  Text('Role: $role'),
                ],
        ),
      ),
    );
  }
}

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final role = context.read<AuthCubit>().state is AuthAuthenticated
        ? (context.read<AuthCubit>().state as AuthAuthenticated).role
        : AppRoles.patient;

    final user = context.read<AuthCubit>().state is AuthAuthenticated
        ? (context.read<AuthCubit>().state as AuthAuthenticated).user
        : null;
    
    return Scaffold(
      appBar: RoleBasedAppBar(title: '${user?.displayName}', displayActions: false,),
      body: Center(
        // user profile details
        child: role == AppRoles.patient
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Name: ${user?.displayName}'),
                  Text('Email: ${user?.email}'),
                  Text('Role: $role'),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Name: ${user?.displayName}'),
                  Text('Email: ${user?.email}'),
                  Text('Role: $role'),
                ],
        ),
      ),
    );
  }
}

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final role = context.read<AuthCubit>().state is AuthAuthenticated
        ? (context.read<AuthCubit>().state as AuthAuthenticated).role
        : AppRoles.patient;

    final user = context.read<AuthCubit>().state is AuthAuthenticated
        ? (context.read<AuthCubit>().state as AuthAuthenticated).user
        : null;
    
    return Scaffold(
      appBar: RoleBasedAppBar(title: '${user?.displayName}', displayActions: false,),
      body: Center(
        // user profile details
        child: role == AppRoles.patient
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Name: ${user?.displayName}'),
                  Text('Email: ${user?.email}'),
                  Text('Role: $role'),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Name: ${user?.displayName}'),
                  Text('Email: ${user?.email}'),
                  Text('Role: $role'),
                ],
        ),
      ),
    );
  }
}