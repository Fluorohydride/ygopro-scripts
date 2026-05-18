--魔鍵－マフテア
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.exconfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end

function s.excon(tp)
	return Duel.IsExistingMatchingCard(s.exconfilter,tp,LOCATION_MZONE,0,1,nil)
end

function s.fusfilter(c)
	return c:IsSetCard(0x165)
end

--- @type FUSION_SPELL_PRE_SELECT_MAT_LOCATION_FUNCTION
function s.pre_select_mat_location(tc,tp)
	local location=LOCATION_HAND|LOCATION_MZONE
	--- Add Deck if controls a Normal Monster
	if Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsType(TYPE_NORMAL) end,tp,LOCATION_MZONE,0,1,nil) then
		location=location|LOCATION_DECK
	end
	return location
end

function s.fusion_spell_matfilter(c)
	--- material from Deck must be Normal Monster
	if c:IsLocation(LOCATION_DECK) and not c:IsType(TYPE_NORMAL) then
		return false
	end
	return true
end

function s.rfilter(c,e,tp)
	return c:IsSetCard(0x165)
end

function s.rexfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end

function s.rcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end

function s.gcheck(sg,ec)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local fusion_effect=FusionSpell.CreateSummonEffect(e:GetHandler(),{
			fusfilter=s.fusfilter,
			pre_select_mat_location=s.pre_select_mat_location,
			fusion_spell_matfilter=s.fusion_spell_matfilter
		})
		if fusion_effect:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0) then
			return true
		end

		local rmg1=Duel.GetRitualMaterial(tp)
		local rmg2
		if s.excon(tp) then
			rmg2=Duel.GetMatchingGroup(s.rexfilter,tp,LOCATION_DECK,0,nil)
		end
		aux.RCheckAdditional=s.rcheck
		aux.RGCheckAdditional=s.gcheck
		local res=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,s.rfilter,e,tp,rmg1,rmg2,Card.GetLevel,"Greater")
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local fusion_effect=FusionSpell.CreateSummonEffect(e:GetHandler(),{
		fusfilter=s.fusfilter,
		matfilter=aux.NecroValleyFilter(),
		pre_select_mat_location=s.pre_select_mat_location,
		fusion_spell_matfilter=s.fusion_spell_matfilter
	})
	local can_fusion=fusion_effect:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0)
	local rmg1=Duel.GetRitualMaterial(tp)
	local rmg2
	if s.excon(tp) then
		rmg2=Duel.GetMatchingGroup(s.rexfilter,tp,LOCATION_DECK,0,nil)
	end
	aux.RCheckAdditional=s.rcheck
	aux.RGCheckAdditional=s.gcheck
	local rsg=Duel.GetMatchingGroup(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,nil,s.rfilter,e,tp,rmg1,rmg2,Card.GetLevel,"Greater")
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
	local off=1
	local ops={}
	local opval={}
	if can_fusion then
		ops[off]=aux.Stringid(id,0)
		opval[off-1]=1
		off=off+1
	end
	if rsg:GetCount()>0 then
		ops[off]=aux.Stringid(id,1)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		fusion_effect:GetOperation()(e,tp,eg,ep,ev,re,r,rp)
	else
		::rcancel::
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=rsg:Select(tp,1,1,nil):GetFirst()
		aux.RCheckAdditional=s.rcheck
		aux.RGCheckAdditional=s.gcheck
		local rmg=rmg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if rmg2 then rmg:Merge(rmg2) end
		if tc.mat_filter then
			rmg=rmg:Filter(tc.mat_filter,tc,tp)
		else
			rmg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=rmg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat then
			aux.RCheckAdditional=nil
			aux.RGCheckAdditional=nil
			goto rcancel
		end
		tc:SetMaterial(mat)
		local dmat=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
		if dmat:GetCount()>0 then
			mat:Sub(dmat)
			Duel.SendtoGrave(dmat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
	end
end
