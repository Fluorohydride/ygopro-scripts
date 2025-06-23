--超越融合
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_MZONE,
		extra_target=s.extra_target,
		additional_fcheck=s.fcheck,
		stage_x_operation=s.stage_x_operation
	})
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCost(s.cost)
	c:RegisterEffect(e1)
	--Summon Materials
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end

function s.fusfilter(c)
	--- fusion monster must have minimium mertial number <= 2, material_count = {min,max} in metatable
	local mt=getmetatable(c)
	if mt~=nil then
		local material_count=mt.material_count
		if material_count~=nil and #material_count>=1 then
			if material_count[1]>2 then
				return false
			end
		end
	end
	return true
end

--- @type FUSION_FGCHECK_FUNCTION
function s.fcheck(tp,mg,fc,mg_all)
	return #mg_all<=2
end

function s.extra_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end

--- @type FUSION_SPELL_STAGE_X_CALLBACK_FUNCTION
function s.stage_x_operation(e,tc,tp,stage)
	if stage==FusionSpell.STAGE_BEFORE_SUMMON_COMPLETE then
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		--- @type Effect
		local e1=e:GetLabelObject()
		if e1~=nil then e1:SetLabelObject(tc) end
	end
end

function s.mgfilter(c,e,tp,fusc,mg)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and c:GetReason()&(REASON_FUSION+REASON_MATERIAL)==(REASON_FUSION+REASON_MATERIAL) and c:GetReasonCard()==fusc
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and fusc:CheckFusionMaterial(mg,c,PLAYER_NONE,true)
end

function s.spfilter(c,e,tp)
	if c:IsFaceup() and c:GetFlagEffect(id)~=0 and c==e:GetLabelObject() then
		local mg=c:GetMaterial()
		local ct=mg:GetCount()
		return ct>0 and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE)
			and mg:FilterCount(s.mgfilter,nil,e,tp,c,mg)==ct
			and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	else return false end
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local mg=tc:GetMaterial()
	local ct=mg:GetCount()
	if ct>0 and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE)
		and mg:FilterCount(s.mgfilter,nil,e,tp,tc,mg)==ct
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		local sc=mg:GetFirst()
		while sc do
			if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e1,true)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e2,true)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_SET_ATTACK_FINAL)
				e3:SetValue(0)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e3,true)
				local e4=e3:Clone()
				e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
				sc:RegisterEffect(e4,true)
			end
			sc=mg:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end
