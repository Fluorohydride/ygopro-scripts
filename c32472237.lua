--メタルヴァレット・ドラゴン
function c32472237.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32472237,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,32472237)
	e1:SetCondition(c32472237.descon)
	e1:SetTarget(c32472237.destg)
	e1:SetOperation(c32472237.desop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c32472237.regop)
	c:RegisterEffect(e2)
end
function c32472237.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsContains(c) then return false end
	return re:IsActiveType(TYPE_LINK)
end
function c32472237.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	if chk==0 then return c:IsDestructable() and cg:GetCount()>0 end
	cg:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,cg,cg:GetCount(),0,0)
end
function c32472237.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 and cg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Destroy(cg,REASON_EFFECT)
	end
end
function c32472237.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_ONFIELD) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(32472237,1))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1,32472238)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetTarget(c32472237.sptg)
		e1:SetOperation(c32472237.spop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c32472237.spfilter(c,e,tp)
	return c:IsSetCard(0x102) and not c:IsCode(32472237) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c32472237.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c32472237.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c32472237.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c32472237.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
