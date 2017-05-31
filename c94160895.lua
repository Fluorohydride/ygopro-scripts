--真竜凰マリアムネ
function c94160895.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(94160895,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,94160895)
	e1:SetTarget(c94160895.sptg)
	e1:SetOperation(c94160895.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(94160895,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,94160896)
	e2:SetCondition(c94160895.thcon)
	e2:SetTarget(c94160895.thtg)
	e2:SetOperation(c94160895.thop)
	c:RegisterEffect(e2)
end
function c94160895.desfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function c94160895.desfilter2(c)
	return c:IsFaceup() and c:GetSequence()<5
end
function c94160895.mzfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c94160895.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>-1 then
		local loc=0
		if Duel.IsPlayerAffectedByEffect(tp,88581108) then loc=LOCATION_MZONE end
		g=Duel.GetMatchingGroup(c94160895.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,loc,c)
	else
		g=Duel.GetMatchingGroup(c94160895.desfilter2,tp,LOCATION_MZONE,0,c)
	end
	if chk==0 then return ft>-2 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and g:GetCount()>=2 and g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WIND)
		and (ft~=0 or g:IsExists(c94160895.mzfilter,1,nil,tp)) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c94160895.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>-1 then
		local loc=0
		if Duel.IsPlayerAffectedByEffect(tp,88581108) then loc=LOCATION_MZONE end
		g=Duel.GetMatchingGroup(c94160895.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,loc,c)
	else
		g=Duel.GetMatchingGroup(c94160895.desfilter2,tp,LOCATION_MZONE,0,c)
	end
	if g:GetCount()<2 or not g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WIND) then return end
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	if ft==0 then
		g1=g:FilterSelect(tp,c94160895.mzfilter,1,1,nil,tp)
	else
		g1=g:Select(tp,1,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	if g1:GetFirst():IsAttribute(ATTRIBUTE_WIND) then
		local g2=g:Select(tp,1,1,g1:GetFirst())
		g1:Merge(g2)
	else
		local g2=g:FilterSelect(tp,Card.IsAttribute,1,1,g1:GetFirst(),ATTRIBUTE_WIND)
		g1:Merge(g2)
	end
	local rm=g1:IsExists(Card.IsAttribute,2,nil,ATTRIBUTE_WIND)
	if Duel.Destroy(g1,REASON_EFFECT)==2 then
		if not c:IsRelateToEffect(e) then return end
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then
			return
		end
		local rg=Duel.GetDecktopGroup(1-tp,4)
		if rm and rg:GetCount()>0 and rg:FilterCount(Card.IsAbleToRemove,nil)==4
			and Duel.SelectYesNo(tp,aux.Stringid(94160895,2)) then
			Duel.DisableShuffleCheck()
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c94160895.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c94160895.thfilter(c)
	return c:GetAttribute()~=ATTRIBUTE_WIND and c:IsRace(RACE_WYRM) and c:IsAbleToHand()
end
function c94160895.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c94160895.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c94160895.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c94160895.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
