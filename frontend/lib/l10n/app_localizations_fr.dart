// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Stockify';

  @override
  String get posSubtitle => 'Système de gestion d\'inventaire';

  @override
  String get loginWelcome => 'Bienvenue';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get enterUsername => 'Entrez votre nom d\'utilisateur';

  @override
  String get password => 'Mot de passe';

  @override
  String get enterPassword => 'Entrez votre mot de passe';

  @override
  String get rememberMe => 'Se souvenir de moi';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get signIn => 'Se connecter';

  @override
  String get navDashboard => 'Tableau de bord';

  @override
  String get navPos => 'Ventes (POS)';

  @override
  String get navSalesHistory => 'Historique des ventes';

  @override
  String get navProductList => 'Liste des produits';

  @override
  String get navAddProduct => 'Ajouter un produit';

  @override
  String get navCategories => 'Catégories';

  @override
  String get navSuppliers => 'Fournisseurs & Commandes';

  @override
  String get navLowStock => 'Alertes de stock bas';

  @override
  String get navStockMovement => 'Mouvement de stock';

  @override
  String get navUserManagement => 'Gestion des utilisateurs';

  @override
  String get logout => 'Déconnexion';

  @override
  String loggedInAs(String role) {
    return 'Connecté en tant que $role';
  }

  @override
  String get posTitle => 'Point de Vente';

  @override
  String get posScanSearch => 'Scannez ou recherchez des produits à ajouter au panier';

  @override
  String get searchItem => 'Scanner ou rechercher un article...';

  @override
  String get cartItems => 'Articles du panier';

  @override
  String get cartEmpty => 'Le panier est vide';

  @override
  String get addProductsToStart => 'Ajoutez des produits pour commencer une vente';

  @override
  String get barcodeInput => 'Entrée code-barres';

  @override
  String get orderSummary => 'Récapitulatif de la commande';

  @override
  String get subtotal => 'Sous-total';

  @override
  String get productTitle => 'Liste des Produits';

  @override
  String get productSubtitle => 'Gérez vos produits en stock.';

  @override
  String get addNewProduct => 'Ajouter un Nouveau Produit';

  @override
  String get editProduct => 'Modifier le Produit';

  @override
  String get updateDetails => 'Mettre à jour les détails du produit';

  @override
  String get filters => 'Filtres';

  @override
  String get nameOrBarcode => 'Nom ou code-barres...';

  @override
  String get allCategories => 'Toutes les catégories';

  @override
  String get allStockLevels => 'Tous les niveaux de stock';

  @override
  String get productName => 'Nom du produit';

  @override
  String get enterProductName => 'Entrez le nom du produit';

  @override
  String get barcode => 'Code-barres';

  @override
  String get barcodeNumber => 'Numéro de code-barres';

  @override
  String get enterBarcode => 'Entrez le numéro de code-barres';

  @override
  String get category => 'Catégorie';

  @override
  String get selectCategory => 'Sélectionner une catégorie';

  @override
  String get supplier => 'Fournisseur';

  @override
  String get enterSupplier => 'Entrez le nom du fournisseur';

  @override
  String get initialQuantity => 'Quantité initiale';

  @override
  String get buyingPrice => 'Prix d\'achat (DA)';

  @override
  String get sellingPrice => 'Prix de vente (DA)';

  @override
  String get description => 'Description';

  @override
  String get enterDescription => 'Entrez la description du produit (facultatif)';

  @override
  String get stock => 'Stock';

  @override
  String get actions => 'Actions';

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String get saveProduct => 'Enregistrer le produit';

  @override
  String get cancel => 'Annuler';

  @override
  String get resetForm => 'Réinitialiser';

  @override
  String get backToProductList => 'Retour à la liste';

  @override
  String get categoryTitle => 'Gestion des Catégories';

  @override
  String get categorySubtitle => 'Organisez les produits par catégories';

  @override
  String get addCategory => 'Ajouter une catégorie';

  @override
  String get editCategory => 'Modifier la catégorie';

  @override
  String get categoryName => 'Nom de la catégorie';

  @override
  String get productCount => 'Nombre de produits';

  @override
  String items(int count) {
    return '$count articles';
  }

  @override
  String get salesHistoryTitle => 'Historique des Ventes';

  @override
  String get salesHistorySubtitle => 'Voir et gérer toutes les transactions';

  @override
  String get exportReport => 'Exporter le rapport';

  @override
  String get searchTransaction => 'Rechercher transaction';

  @override
  String get transactionId => 'ID Transaction';

  @override
  String get date => 'Date';

  @override
  String get paymentMethod => 'Mode de paiement';

  @override
  String get allMethods => 'Toutes les méthodes';

  @override
  String get cashier => 'Caissier';

  @override
  String get allCashiers => 'Tous les caissiers';

  @override
  String get totalTransactions => 'Total Transactions';

  @override
  String get totalSales => 'Ventes Totales';

  @override
  String get averageTransaction => 'Transaction moyenne';

  @override
  String get dateTime => 'Date et Heure';

  @override
  String get status => 'Statut';

  @override
  String get deleteProduct => 'Supprimer le produit';

  @override
  String deleteConfirm(String productName) {
    return 'Êtes-vous sûr de vouloir supprimer $productName ?';
  }

  @override
  String get delete => 'Supprimer';
}
