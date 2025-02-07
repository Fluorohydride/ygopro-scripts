--ジェムナイトマスター・ダイヤ－ディスパージョン
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x47),3,true)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--spsummon from grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.spcon2)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.spfilter1(c,e,tp,ec)
	return c:IsSetCard(0x47) and not c:IsRace(RACE_ROCK) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and (c:IsLocation(LOCATION_GRAVE) and Duel.GetMZoneCount(tp,c)>0
		or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,ec,c)>0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if chk==0 then return (not ect or ect>0) and Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function s.spfilter2(c,e,tp)
	if not (c:IsSetCard(0x47) and not c:IsRace(RACE_ROCK) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)) then return false end
	if c:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	else
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
end
function s.exfilter1(c)
	return c:IsLocation(LOCATION_EXTRA) and c:IsFacedown() and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end
function s.exfilter2(c)
	return c:IsLocation(LOCATION_EXTRA) and (c:IsType(TYPE_LINK) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
end
function s.gcheck(g,ft1,ft2,ft3,ect,ft)
	return aux.dncheck(g) and #g<=ft
		and g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=ft1
		and g:FilterCount(s.exfilter1,nil)<=ft2
		and g:FilterCount(s.exfilter2,nil)<=ft3
		and g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=ect
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local eft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local eft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
	local eft3=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM+TYPE_LINK)
	local ft=Duel.GetUsableMZoneCount(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if eft1>0 then eft1=1 end
		if eft2>0 then eft2=1 end
		if eft3>0 then eft3=1 end
		ft=1
	end
	local ect=(c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]) or ft
	local loc=0
	if eft1>0 then loc=loc+LOCATION_GRAVE end
	if ect>0 and (eft2>0 or eft3>0) then loc=loc+LOCATION_EXTRA end
	if loc~=0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter2),tp,loc,0,nil,e,tp)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:SelectSubGroup(tp,s.gcheck,false,1,3,eft1,eft2,eft3,ect,ft)
			if sg:GetCount()>0 then
				local exg1=sg:Filter(s.exfilter2,nil)
				sg:Sub(exg1)
				if exg1:GetCount()>0 then
					for tc in aux.Next(exg1) do
						Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
					end
				end
				local exg2=sg:Filter(s.exfilter1,nil)
				sg:Sub(exg2)
				if exg2:GetCount()>0 then
					for tc in aux.Next(exg2) do
						Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
					end
				end
				if sg:GetCount()>0 then
					for tc in aux.Next(sg) do
						Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
					end
				end
				Duel.SpecialSummonComplete()
			end
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return not c:IsType(TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA)
end
function s.cfilter(c,tp)
	return c:IsType(TYPE_FUSION) and c:IsPreviousControler(tp)
		and c:IsPreviousSetCard(0x1047)
		and c:IsSetCard(0x1047)
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,e:GetHandler(),tp)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and aux.NecroValleyFilter()(c) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
