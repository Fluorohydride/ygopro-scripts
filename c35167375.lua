--サプライズ・フュージョン
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--tokend
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.rafilter(c)
	return c:IsFaceup() and ((RACE_ALL&~c:GetRace())~=0 or (ATTRIBUTE_ALL&~c:GetAttribute())~=0)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() and s.rafilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.rafilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,s.rafilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	local race,att
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	if ATTRIBUTE_ALL&~tc:GetAttribute()==0 then
		race=Duel.AnnounceRace(tp,1,RACE_ALL&~tc:GetRace())
	else
		race=Duel.AnnounceRace(tp,1,RACE_ALL)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	if RACE_ALL&~tc:GetRace()==0 or race==tc:GetRace() then
		att=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL&~tc:GetAttribute())
	else
		att=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
	end
	e:SetLabel(race,att)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local race,att=e:GetLabel()
	local ec=Duel.GetFirstTarget()
	if ec:IsRelateToChain() and ec:IsFaceup() and ec:IsType(TYPE_MONSTER) then
		local cres=ec:GetRace()~=race or ec:GetAttribute()~=att
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(race)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(att)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e2)
		Duel.AdjustAll()
		if ec:IsControler(1-tp) or not cres then return end
		local fusion_effect=FusionSpell.CreateSummonEffect(c,{
			pre_select_mat_location=LOCATION_MZONE,
			gc=function() return ec end
		})
		if fusion_effect:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0)
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			fusion_effect:GetOperation()(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end
function s.cfilter(c,tp,chk)
	return c:IsType(TYPE_FUSION) and c:IsReleasableByEffect() and (not chk
		or (Duel.GetMZoneCount(tp,c)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0,TYPES_TOKEN_MONSTER,0,0,c:GetLevel(),RACE_SPELLCASTER,ATTRIBUTE_DARK)))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetReleaseGroup(tp,false,REASON_EFFECT)
	if chk==0 then return rg:IsExists(s.cfilter,1,nil,tp,true) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetReleaseGroup(tp,false,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local srg=nil
	local chk=Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil,tp,true)
	srg=rg:FilterSelect(tp,s.cfilter,1,1,nil,tp,chk)
	if srg and srg:GetCount()>0 then
		local rc=srg:GetFirst()
		local level=rc:GetLevel()
		if Duel.Release(rc,REASON_EFFECT)>0
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
			and not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0,TYPES_TOKEN_MONSTER,0,0,level,RACE_SPELLCASTER,ATTRIBUTE_DARK) then
			for i=1,2 do
				local token=Duel.CreateToken(tp,id+o)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LEVEL)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				e1:SetValue(level)
				token:RegisterEffect(e1,true)
				Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
