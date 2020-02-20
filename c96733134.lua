--覇王眷竜オッドアイズ
function c96733134.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(96733134,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(c96733134.thcost)
	e1:SetTarget(c96733134.thtg)
	e1:SetOperation(c96733134.thop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(96733134,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c96733134.hspcost)
	e2:SetTarget(c96733134.hsptg)
	e2:SetOperation(c96733134.hspop)
	c:RegisterEffect(e2)
	--double damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c96733134.damtg)
	e3:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(96733134,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMING_BATTLE_START)
	e4:SetCondition(c96733134.spcon)
	e4:SetCost(c96733134.spcost)
	e4:SetTarget(c96733134.sptg)
	e4:SetOperation(c96733134.spop)
	c:RegisterEffect(e4)
end
function c96733134.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,0x20f8) end
	local sg=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,nil,0x20f8)
	Duel.Release(sg,REASON_COST)
end
function c96733134.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAttackBelow(1500) and c:IsAbleToHand()
end
function c96733134.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c96733134.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c96733134.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c96733134.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c96733134.rfilter(c,tp)
	return c:IsSetCard(0x20f8) and (c:IsControler(tp) or c:IsFaceup())
end
function c96733134.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetReleaseGroup(tp):Filter(c96733134.rfilter,nil,tp)
	if chk==0 then return rg:CheckSubGroup(aux.mzctcheckrel,2,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=rg:SelectSubGroup(tp,aux.mzctcheckrel,false,2,2,tp)
	Duel.Release(g,REASON_COST)
end
function c96733134.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c96733134.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c96733134.damtg(e,c)
	return c:IsType(TYPE_PENDULUM) and c:GetBattleTarget()~=nil
end
function c96733134.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function c96733134.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end
function c96733134.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x10f8,0x20f8)
		and c:IsType(TYPE_PENDULUM) and not c:IsCode(96733134)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and Duel.GetLocationCountFromEx(tp,tp,rc,c)>0
end
function c96733134.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c96733134.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c96733134.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	if ft==0 then return end
	ft=math.min(ft,2)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		ft=1
	end
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect~=nil then ft=math.min(ft,ect) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c96733134.spfilter,tp,LOCATION_EXTRA,0,1,ft,nil,e,tp,nil)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
