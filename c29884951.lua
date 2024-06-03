--相剣瑞獣－純鈞
function c29884951.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29884951,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,29884951)
	e1:SetCondition(c29884951.spcon)
	e1:SetCost(c29884951.spcost)
	e1:SetTarget(c29884951.sptg)
	e1:SetOperation(c29884951.spop)
	c:RegisterEffect(e1)
	--des
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29884951,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c29884951.descon)
	e2:SetTarget(c29884951.destg)
	e2:SetOperation(c29884951.desop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29884951,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,29884952)
	e3:SetCondition(c29884951.remcon)
	e3:SetTarget(c29884951.remtg)
	e3:SetOperation(c29884951.remop)
	c:RegisterEffect(e3)
end
function c29884951.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c29884951.rfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp,c)>0
end
function c29884951.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c29884951.rfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c29884951.rfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c29884951.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29884951.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c29884951.descon(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetBattleMonster(tp)
	return a and d and a:IsFaceup() and a:IsRelateToBattle() and a:IsRace(RACE_WYRM)
		and d:IsFaceup() and d:IsRelateToBattle() and d:IsSummonLocation(LOCATION_EXTRA)
end
function c29884951.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local a,d=Duel.GetBattleMonster(tp)
	local g=Group.FromCards(d,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c29884951.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a,d=Duel.GetBattleMonster(tp)
	if c:IsFaceup() and c:IsRelateToEffect(e) and d and d:IsRelateToBattle() then
		local g=Group.FromCards(d,c)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c29884951.remcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c29884951.remfilter(c)
	return c:IsAbleToRemove()
end
function c29884951.remtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and c29884951.remfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c29884951.remfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=aux.SelectCardFromFieldFirst(tp,c29884951.remfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c29884951.remop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
