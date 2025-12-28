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
  String get navSuppliers => 'Fournisseurs';

  @override
  String get navThresholds => 'Seuils';

  @override
  String get navLowStock => 'Alertes de stock bas';

  @override
  String get navStockMovement => 'Mouvement de stock';

  @override
  String get navUserManagement => 'Gestion des utilisateurs';

  @override
  String get logout => 'Déconnexion';

  @override
  String get loggedInAs => 'Connecté en tant que ';

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
  String get orderSummary => 'Récapitulatif de l\'achat ';

  @override
  String get subtotal => 'Sous-total';

  @override
  String get tax_10 => 'Taxe(10%)';

  @override
  String get cash => 'Espèces';

  @override
  String get card => 'Carte';

  @override
  String get complete_transaction => 'Finaliser la transaction';

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
  String get edit => 'Modifier';

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
  String get stockLevel => 'Niveau de stock';

  @override
  String get inStock => 'En stock';

  @override
  String get lowStock => 'Stock faible';

  @override
  String get veryLowStock => 'Stock très faible';

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
  String get selectCategoryMsg => 'Veuillez sélectionner une catégorie';

  @override
  String get productAddedMsg => 'Produit ajouté avec succès';

  @override
  String get failedToLoadProductMsg => 'Échec de l’ajout du produit : ';

  @override
  String get enterProductDetails => 'Entrez les détails du produit à ajouter à l’inventaire';

  @override
  String get plzEnterProductName => 'Veuillez saisir le nom du produit';

  @override
  String get plzEnterInitialQty => 'Veuillez saisir la quantité initiale';

  @override
  String get plzEnterValidNum => 'Veuillez saisir un nombre valide';

  @override
  String get plzEnterPrice => 'Veuillez saisir le prix';

  @override
  String get plzEnterValidPrice => 'Veuillez saisir un prix valide';

  @override
  String get plzSelectCategory => 'Veuillez sélectionner une catégorie';

  @override
  String get productUpdatedMsg => 'Produit mis à jour avec succès !';

  @override
  String get failedToUpdateProductMsg => 'Échec de la mise à jour du produit :';

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
  String get deleteConfirm => 'Êtes-vous sûr de vouloir supprimer';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleted => 'supprimé';

  @override
  String get viewBatches => 'Voir les lots';

  @override
  String get productBatchesTitle => 'Lots de produit';

  @override
  String get manageBatchesDescription => 'Gérer les lots pour ce produit';

  @override
  String get backToProducts => 'Retour aux produits';

  @override
  String get createNewBatch => 'Créer un nouveau lot';

  @override
  String get totalBatches => 'Total des lots';

  @override
  String get totalQuantity => 'Quantité totale';

  @override
  String get expired => 'Expiré';

  @override
  String get nearExpiry => 'Expiration proche';

  @override
  String get noBatchesFound => 'Aucun lot trouvé pour ce produit';

  @override
  String get createFirstBatch => 'Créez votre premier lot';

  @override
  String get batchId => 'ID du lot';

  @override
  String get quantity => 'Quantité';

  @override
  String get mfgDate => 'Date de fab.';

  @override
  String get expiryDate => 'Date d\'expiration';

  @override
  String get units => 'unités';

  @override
  String get noExpiry => 'Pas d\'expiration';

  @override
  String get expiresIn => 'Expire dans';

  @override
  String get days => 'jours';

  @override
  String get valid => 'Valide';

  @override
  String get unknown => 'Inconnu';

  @override
  String get editBatch => 'Modifier le lot';

  @override
  String get deleteBatch => 'Supprimer le lot';

  @override
  String get deleteConfirmation => 'Êtes-vous sûr de vouloir supprimer ce lot ?';

  @override
  String get deleteSuccess => 'supprimé avec succès';

  @override
  String get loadError => 'Échec du chargement des lots';

  @override
  String get deleteError => 'Échec de la suppression du lot';

  @override
  String get na => 'N/A';

  @override
  String get productLabel => 'Produit';

  @override
  String get backToBatches => 'Retour aux lots';

  @override
  String get enterQuantityHint => 'Entrez la quantité du lot';

  @override
  String get pleaseEnterQuantity => 'Veuillez entrer une quantité';

  @override
  String get enterValidNumber => 'Veuillez entrer un nombre valide';

  @override
  String get quantityGreaterThanZero => 'La quantité doit être supérieure à 0';

  @override
  String get manufactureDate => 'Date de fabrication';

  @override
  String get notSelected => 'Non sélectionné';

  @override
  String get updateBatch => 'Mettre à jour le lot';

  @override
  String get createBatch => 'Créer le lot';

  @override
  String get batchUpdatedSuccess => 'Lot mis à jour avec succès !';

  @override
  String get batchCreatedSuccess => 'Lot créé avec succès !';

  @override
  String get failedToLoadBatch => 'Échec du chargement du lot';

  @override
  String get failedToSaveBatch => 'Échec de l\'enregistrement du lot';
}
