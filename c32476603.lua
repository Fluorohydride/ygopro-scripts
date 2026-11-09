--シルバーヴァレット・ドラゴン
function c32476603.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32476603,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,32476603)
	e1:SetCondition(c32476603.descon)
	e1:SetTarget(c32476603.destg)
	e1:SetOperation(c32476603.desop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c32476603.regop)
	c:RegisterEffect(e2)
end
function c32476603.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsContains(c) then return false end
	return re:IsActiveType(TYPE_LINK)
end
function c32476603.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
	if chk==0 then return c:IsDestructable() and g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c32476603.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if e:GetHandler():IsRelateToEffect(e) and Duel.Destroy(e:GetHandler(),REASON_EFFECT)>0 and g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
		if tg:GetCount()>0 then
			Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		end
		Duel.ShuffleExtra(1-tp)
	end
end
function c32476603.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_ONFIELD) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(32476603,1))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1,32476604)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetTarget(c32476603.sptg)
		e1:SetOperation(c32476603.spop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c32476603.spfilter(c,e,tp)
	return c:IsSetCard(0x102) and not c:IsCode(32476603) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c32476603.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c32476603.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c32476603.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c32476603.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
