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
  String get categorySubtitle => 'Organisez vos produits par catégories';

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

  @override
  String get lowStockDescription => 'Surveiller les produits avec un niveau de stock bas';

  @override
  String get totalAlerts => 'Total des alertes';

  @override
  String get lowStockItems => 'Articles en stock bas';

  @override
  String get searchAlertsHint => 'Rechercher par nom ou catégorie...';

  @override
  String get refresh => 'Actualiser';

  @override
  String get noLowStockAlerts => 'Aucune alerte de stock bas';

  @override
  String get noAlertsMatch => 'Aucune alerte ne correspond à votre recherche';

  @override
  String get allStockSufficient => 'Tous les produits ont un niveau de stock suffisant';

  @override
  String get tryDifferentSearch => 'Essayez un autre terme de recherche';

  @override
  String get currentStock => 'Stock actuel';

  @override
  String get threshold => 'Seuil';

  @override
  String get notAvailable => 'N/D';

  @override
  String get critical => 'Critique';

  @override
  String get warning => 'Avertissement';

  @override
  String get categoryManagement => 'Gestion des Catégories';

  @override
  String get totalCategories => 'Total des catégories';

  @override
  String get totalProducts => 'Total des produits';

  @override
  String get avgProducts => 'Moyenne produits/catégorie';

  @override
  String get confirmDelete => 'Confirmer la suppression';

  @override
  String get deleteConfirmationMsg => 'Êtes-vous sûr de vouloir supprimer cette catégorie ? Cette action est irréversible.';

  @override
  String get save => 'Enregistrer';

  @override
  String get successDelete => 'Catégorie supprimée avec succès';

  @override
  String get failDelete => 'Échec de la suppression de la catégorie';

  @override
  String get itemsLabel => 'articles';

  @override
  String get errorDeletingCategory => 'Erreur lors de la suppression de la catégorie: ';

  @override
  String get errorLoadingCategories => 'Erreur lors du chargement des catégories :';

  @override
  String get thresholdManagement => 'Gestion des Seuils';

  @override
  String get thresholdSubtitle => 'Gérer les seuils de stock bas pour les produits et catégories';

  @override
  String get addThreshold => 'Ajouter un seuil';

  @override
  String get editThreshold => 'Modifier le seuil';

  @override
  String get thresholdInfo => 'Informations sur le seuil';

  @override
  String get thresholdType => 'Type de seuil';

  @override
  String get totalProductThresholds => 'Total des seuils produits';

  @override
  String get noThresholdsFound => 'Aucun seuil trouvé';

  @override
  String get search => 'Rechercher';

  @override
  String get searchPlaceholder => 'Rechercher par nom de produit ou catégorie...';

  @override
  String get type => 'Type';

  @override
  String get productCategory => 'Produit/Catégorie';

  @override
  String get thresholdValue => 'Valeur du seuil';

  @override
  String get createdAt => 'Créé le';

  @override
  String get product => 'Produit';

  @override
  String get setProductThreshold => 'Définir un seuil pour un produit spécifique';

  @override
  String get setCategoryThreshold => 'Définir un seuil pour tous les produits d\'une catégorie';

  @override
  String get selectProduct => 'Sélectionner un produit';

  @override
  String get chooseProduct => 'Choisir un produit...';

  @override
  String get chooseCategory => 'Choisir une catégorie...';

  @override
  String get enterThresholdValue => 'Entrez la valeur du seuil...';

  @override
  String get backToList => 'Retour à la liste';

  @override
  String get saveThreshold => 'Enregistrer le seuil';

  @override
  String get deleteThreshold => 'Supprimer le seuil';

  @override
  String get deleteThresholdConfirm => 'Êtes-vous sûr de vouloir supprimer le seuil pour cet élément ?';

  @override
  String get errorLoadingThresholds => 'Erreur lors du chargement des seuils :';

  @override
  String get errorLoadingData => 'Erreur lors du chargement des données :';

  @override
  String get errorDeletingThreshold => 'Erreur lors de la suppression du seuil :';

  @override
  String get errorCreatingThreshold => 'Erreur lors de la création du seuil :';

  @override
  String get thresholdDeleteSuccess => 'Seuil supprimé avec succès';

  @override
  String get thresholdCreateSuccess => 'Seuil créé avec succès';

  @override
  String get thresholdUpdateSuccess => 'Seuil mis à jour avec succès';

  @override
  String get pleaseSelectProduct => 'Veuillez sélectionner un produit';

  @override
  String get pleaseSelectCategory => 'Veuillez sélectionner une catégorie';

  @override
  String get pleaseEnterValue => 'Veuillez entrer une valeur de seuil';

  @override
  String get pleaseEnterPositive => 'Veuillez entrer un nombre positif valide';

  @override
  String get addThresholdDescription => 'Créez un nouveau seuil de stock bas pour un produit ou une catégorie';

  @override
  String get editThresholdDescription => 'Modifier la valeur du seuil de stock bas';

  @override
  String get thresholdInformation => 'Informations sur le seuil';

  @override
  String get productThreshold => 'Seuil du produit';

  @override
  String get categoryThreshold => 'Seuil de la catégorie';

  @override
  String get categoryWarningNote => 'Note : La mise à jour de ce seuil s\'appliquera à tous les produits de cette catégorie';

  @override
  String get thresholdValueLabel => 'Valeur du seuil';

  @override
  String get thresholdValueHint => 'Entrez la valeur du seuil...';

  @override
  String get removeThreshold => 'Supprimer le seuil';

  @override
  String get updateThreshold => 'Mettre à jour le seuil';

  @override
  String get confirmUpdateTitle => 'Confirmer la mise à jour du seuil';

  @override
  String get confirmUpdateBody => 'Vous êtes sur le point de mettre à jour le seuil pour :';

  @override
  String get newThreshold => 'Nouveau seuil';

  @override
  String get categoryWarningDetail => 'Cela mettra à jour TOUS les produits de la catégorie: ';

  @override
  String get productSuccessDetail => 'Cela mettra à jour le seuil uniquement pour: ';

  @override
  String get removeConfirmTitle => 'Supprimer le seuil';

  @override
  String get removeConfirmBody => 'Êtes-vous sûr de vouloir supprimer ce seuil? \n\nNote : Pour les seuils de produits, cela définira le seuil sur nul. Pour les seuils de catégories, cela définira le seuil sur nul pour tout les produits qui appartient à cette catégorie';

  @override
  String get successUpdate => 'Seuil mis à jour avec succès';

  @override
  String get successRemove => 'Seuil supprimé avec succès';

  @override
  String get errorUpdate => 'Erreur lors de la mise à jour du seuil : ';

  @override
  String get errorLoading => 'Erreur lors du chargement du seuil : ';

  @override
  String get validationEmpty => 'Veuillez entrer une valeur de seuil';

  @override
  String get validationInvalid => 'Veuillez entrer un nombre positif valide';

  @override
  String get update => 'Mettre à jour';

  @override
  String get remove => 'Supprimer';
}
