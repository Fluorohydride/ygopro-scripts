--獣神王バルバロス
function c63972571.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(63972571,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,63972571)
	e1:SetCost(c63972571.spcost)
	e1:SetTarget(c63972571.sptg)
	e1:SetOperation(c63972571.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(63972571,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,63972572)
	e2:SetCost(c63972571.descost)
	e2:SetTarget(c63972571.destg)
	e2:SetOperation(c63972571.desop)
	c:RegisterEffect(e2)
	--attack all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c63972571.rfilter(c,tp)
	return c:IsLevelAbove(1) and (c:IsControler(tp) or c:IsFaceup())
end
function c63972571.fselect(g,tp)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetLevel,8) and aux.mzctcheckrel(g,tp)
end
function c63972571.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetReleaseGroup(tp):Filter(c63972571.rfilter,nil,tp)
	if chk==0 then return g:CheckSubGroup(c63972571.fselect,1,g:GetCount(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:SelectSubGroup(tp,c63972571.fselect,false,1,g:GetCount(),tp)
	Duel.Release(rg,REASON_COST)
end
function c63972571.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c63972571.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c63972571.cfilter(c)
	return c:IsSetCard(0x13e) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
		and c:IsAbleToRemoveAsCost()
end
function c63972571.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c63972571.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c63972571.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c63972571.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(aux.TURE,tp,0,LOCATION_ONFIELD,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TURE,tp,0,LOCATION_ONFIELD,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c63972571.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(tg,REASON_EFFECT)
end
