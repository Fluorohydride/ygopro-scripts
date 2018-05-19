--ベクター・スケア・デーモン
function c13452889.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_CYBERSE),2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13452889,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(aux.bdogcon)
	e1:SetCost(c13452889.spcost)
	e1:SetTarget(c13452889.sptg)
	e1:SetOperation(c13452889.spop)
	c:RegisterEffect(e1)
end
function c13452889.cfilter(c,tp,g,zone)
	return g:IsContains(c) and (Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_TOFIELD,zone[tp])>0
		or Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone[1-tp])>0)
end
function c13452889.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	local zone={}
	zone[0]=c:GetLinkedZone(0)
	zone[1]=c:GetLinkedZone(1)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c13452889.cfilter,1,nil,tp,lg,zone) end
	local g=Duel.SelectReleaseGroup(tp,c13452889.cfilter,1,1,nil,tp,lg,zone)
	Duel.Release(g,REASON_COST)
end
function c13452889.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local zone=c:GetLinkedZone(1-tp)
	if chk==0 then return bc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		or bc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp,zone) end
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,bc,1,0,0)
end
function c13452889.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local zone1=c:GetLinkedZone(tp)
		local zone2=c:GetLinkedZone(1-tp)
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone1)
			and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp,zone2) or Duel.SelectYesNo(tp,aux.Stringid(13452889,1))) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone1)
		else
			if Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP,zone2)~=0
				and c:IsRelateToBattle() then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EXTRA_ATTACK)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
				c:RegisterEffect(e1)
			end
		end
	end
end
