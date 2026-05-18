--合成獣融合
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,4796100,5818798,77207191)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		additional_fcheck=s.fcheck
	})
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCondition(s.fscon)
	c:RegisterEffect(e1)
	--move from gy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.gycon)
	e2:SetTarget(s.gytg)
	e2:SetOperation(s.gyop)
	c:RegisterEffect(e2)
end

function s.fscon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end

--- @type FUSION_FGCHECK_FUNCTION
function s.fcheck(tp,mg,fc,mg_all)
	return mg_all:IsExists(function(c) return c:IsRace(RACE_BEAST|RACE_FIEND) end,1,nil)
end

function s.cfilter(c)
	return c:IsFaceupEx() and c:IsCode(4796100)
end

function s.gycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil)
end

function s.sfilter(c,e,tp)
	return c:IsCode(5818798,77207191) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:IsAbleToHand()
	local g=Duel.GetMatchingGroup(s.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	local b2=c:IsAbleToRemove() and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and g:GetClassCount(Card.GetCode)>1
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(id,2)},{b2,aux.Stringid(id,3)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	else
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
	end
end
function s.gyop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		s.tohand(e,tp,eg,ep,ev,re,r,rp)
	elseif op==2 then
		s.banish(e,tp,eg,ep,ev,re,r,rp)
	end
end
function s.tohand(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SendtoHand(c,nil,REASON_EFFECT) end
end

function s.banish(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Remove(c,POS_FACEUP,REASON_EFFECT)==0
		or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.sfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	if sg then Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) end
end
