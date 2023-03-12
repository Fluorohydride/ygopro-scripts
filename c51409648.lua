--撃鉄竜リンドブルム
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--material
	aux.AddFusionProcCodeFun(c,68468459,aux.FilterBoolFunction(Card.IsRace,RACE_BEAST+RACE_BEASTWARRIOR+RACE_WINDBEAST),1,true,true)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.discon)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
		and Duel.IsChainDisablable(ev)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if Duel.NegateEffect(ev) and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.BreakEffect()
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.filter(c,ec,e,tp)
	if not c:IsCode(68468459) then return false end
	local g=Group.FromCards(c,ec)
	return g:IsExists(s.ofilter,1,nil,g,e,tp)
end
function s.ofilter(c,g,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and g:IsExists(Card.IsAbleToRemove,1,c)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter(chkc,c,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local fg=(Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)+e:GetHandler()):Filter(Card.IsRelateToEffect,nil,e)
	if fg:GetCount()~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=fg:FilterSelect(tp,s.ofilter,1,1,nil,fg,e,tp)
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)>0 then Duel.Remove(fg-sg,POS_FACEUP,REASON_EFFECT) end
end
