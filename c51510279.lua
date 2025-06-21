--繋がれし魔鍵
local s,id,o=GetID()
function s.initial_effect(c)
	--- fusion effect
	local e0=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		matfilter=aux.NecroValleyFilter(),
		sumpos=POS_FACEUP_DEFENSE
	})
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
end

function s.thfilter(c)
	return (c:IsType(TYPE_NORMAL) or c:IsSetCard(0x165) and c:IsType(TYPE_MONSTER)) and c:IsAbleToHand()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function s.fusfilter(c)
	return c:IsSetCard(0x165)
end

function s.rfilter(c,e,tp)
	return c:IsSetCard(0x165) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true,POS_FACEUP_DEFENSE)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local th=Duel.GetFirstTarget()
	if not th:IsRelateToEffect(e) or Duel.SendtoHand(th,nil,REASON_EFFECT)==0 or not th:IsLocation(LOCATION_HAND) then return end
	local fusion_effect=e:GetLabelObject()
	local rmg1=Duel.GetRitualMaterial(tp)
	local rsg=Duel.GetMatchingGroup(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,nil,s.rfilter,e,tp,rmg1,nil,Card.GetLevel,"Greater")
	local off=1
	local ops={}
	local opval={}
	ops[off]=aux.Stringid(id,0)
	opval[off-1]=0
	off=off+1
	if fusion_effect:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0) then
		ops[off]=aux.Stringid(id,1)
		opval[off-1]=1
		off=off+1
	end
	if rsg:GetCount()>0 then
		ops[off]=aux.Stringid(id,2)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.BreakEffect()
		fusion_effect:GetOperation()(e,tp,eg,ep,ev,re,r,rp)
	elseif opval[op]==2 then
		::rcancel::
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=rsg:Select(tp,1,1,nil):GetFirst()
		local rmg=rmg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			rmg=rmg:Filter(tc.mat_filter,tc,tp)
		else
			rmg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=rmg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat then goto rcancel end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP_DEFENSE)
		tc:CompleteProcedure()
	end
end
