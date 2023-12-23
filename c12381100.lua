--究極竜魔導師
function c12381100.initial_effect(c)
	aux.AddMaterialCodeList(c,23995346)
	aux.AddCodeList(c,23995346)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c12381100.FShaddollCondition())
	e1:SetOperation(c12381100.FShaddollOperation())
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12381100,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c12381100.discon)
	e2:SetTarget(c12381100.distg)
	e2:SetOperation(c12381100.disop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12381100,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c12381100.spcon)
	e3:SetTarget(c12381100.sptg)
	e3:SetOperation(c12381100.spop)
	c:RegisterEffect(e3)
	if not c12381100.global_check then
		c12381100.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(c12381100.count)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetOperation(c12381100.reset)
		Duel.RegisterEffect(ge2,0)
	end
end
function c12381100.count(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsCode(71143015) then
		c12381100.chain_solving=true
	end
end
function c12381100.reset(e,tp,eg,ep,ev,re,r,rp)
	c12381100.chain_solving=false
end
function c12381100.FShaddollFilter(c)
	return c:IsFusionSetCard(0xdd) or c:IsFusionSetCard(0xcf) and c:IsFusionType(TYPE_RITUAL) or c:IsFusionCode(23995346) or c:IsHasEffect(EFFECT_FUSION_SUBSTITUTE)
end
function c12381100.Ultimate_FShaddollFilter(c)
	return c:IsFusionSetCard(0xdd) or (c:IsFusionSetCard(0xcf) and c:IsFusionType(TYPE_RITUAL)) or c:IsFusionCode(23995346)
end
function c12381100.Chaos_FShaddollFilter(c,mg,fc,chkf)
	return c:IsFusionSetCard(0xcf) and c:IsFusionType(TYPE_RITUAL) and mg:CheckSubGroup(c12381100.FShaddollSpgcheck,1,3,fc,c,chkf)
end
function c12381100.Unnecessary_Chaos_FShaddollFilter(c)
	return c:IsFusionSetCard(0xcf) and c:IsFusionType(TYPE_RITUAL) and not (c:IsFusionSetCard(0xdd) or c:IsFusionCode(23995346) or c:IsHasEffect(EFFECT_FUSION_SUBSTITUTE))
end
function c12381100.Blue_Eyes_Ultimate_Dragon(c)
	return c:IsFusionCode(23995346) and not c:IsHasEffect(EFFECT_FUSION_SUBSTITUTE)
		or c:IsHasEffect(EFFECT_FUSION_SUBSTITUTE)
end
function c12381100.FShaddollSpgcheck(g,fc,ec,chkf)
	local sg=g:Clone()
	sg:AddCard(ec)
	local c=g:Filter(c12381100.Blue_Eyes_Ultimate_Dragon,nil):GetFirst()
	if aux.FCheckAdditional and not aux.FCheckAdditional(tp,sg,fc)
		or aux.FGoalCheckAdditional and not aux.FGoalCheckAdditional(tp,sg,fc)  then return false end
	return ((g:FilterCount(c12381100.Blue_Eyes_Ultimate_Dragon,nil)==1
		and g:FilterCount(Card.IsFusionSetCard,c,0xdd)==0
		or g:FilterCount(Card.IsFusionSetCard,nil,0xdd)==3)
		and (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0))
		and g:FilterCount(c12381100.Unnecessary_Chaos_FShaddollFilter,nil)==0
end
function c12381100.Necessarily_FShaddollFilter(c,gc)
	return c:IsCode(gc:GetCode())
end
function c12381100.Necessarily_FShaddollSpgcheck(g,gc,fc,ec,chkf)
	local c=g:Filter(c12381100.Blue_Eyes_Ultimate_Dragon,nil):GetFirst()
	local sg=g:Clone()
	sg:AddCard(ec)
	if aux.FCheckAdditional and not aux.FCheckAdditional(tp,sg,fc)
		or aux.FGoalCheckAdditional and not aux.FGoalCheckAdditional(tp,sg,fc)  then return false end
	return (((g:FilterCount(c12381100.Blue_Eyes_Ultimate_Dragon,nil)==1
		and g:FilterCount(Card.IsFusionSetCard,c,0xdd)==0
		or g:FilterCount(Card.IsFusionSetCard,nil,0xdd)==3) and g:FilterCount(c12381100.Necessarily_FShaddollFilter,nil,gc)==1)
		and (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0))
		and g:FilterCount(c12381100.Unnecessary_Chaos_FShaddollFilter,nil)==0
end
function c12381100.FShaddollCondition()
	return  function(e,g,gc,chkf)
			if g==nil then return aux.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
			local fc=e:GetHandler()
			local tp=e:GetHandlerPlayer()
			local mg=g:Filter(c12381100.FShaddollFilter,nil)
			if gc then
				if not mg:IsContains(gc) then return false end
			end
			return mg:IsExists(c12381100.Chaos_FShaddollFilter,1,nil,mg,fc,chkf)
		end
end
function c12381100.FShaddollOperation()
	return  function(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
			local fc=e:GetHandler()
			local tp=e:GetHandlerPlayer()
			local mg=nil
			if c12381100.chain_solving then
				mg=eg:Filter(c12381100.Ultimate_FShaddollFilter,nil)
			else
				mg=eg:Filter(c12381100.FShaddollFilter,nil)
			end
			local g=nil
			if gc and c12381100.Chaos_FShaddollFilter(gc,mg,fc,chkf) then
				g=Group.FromCards(gc)
				mg:RemoveCard(gc)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				g=mg:FilterSelect(tp,c12381100.Chaos_FShaddollFilter,1,1,nil,mg,fc,chkf)
				mg:Sub(g)
			end
			local sg=nil
			if gc and g:FilterCount(c12381100.Necessarily_FShaddollFilter,nil,gc)==1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				sg=mg:SelectSubGroup(tp,c12381100.FShaddollSpgcheck,false,1,3,fc,g:GetFirst(),chkf)
			else
				if gc then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					sg=mg:SelectSubGroup(tp,c12381100.Necessarily_FShaddollSpgcheck,false,1,3,gc,fc,g:GetFirst(),chkf)
				else
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					sg=mg:SelectSubGroup(tp,c12381100.FShaddollSpgcheck,true,1,3,fc,g:GetFirst(),chkf)
				end
			end
			while not sg do
				mg:AddCard(g:GetFirst())
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				g=mg:FilterSelect(tp,c12381100.Chaos_FShaddollFilter,1,1,nil,mg,e)
				mg:Sub(g)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				sg=mg:SelectSubGroup(tp,c12381100.FShaddollSpgcheck,true,1,3,fc,g:GetFirst(),chkf)
			end
			g:Merge(sg)
			Duel.SetFusionMaterial(g)
		end
end
function c12381100.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
		and ((re:IsActiveType(TYPE_MONSTER) and Duel.GetFlagEffect(tp,12381100)==0)
		or (re:IsActiveType(TYPE_SPELL) and Duel.GetFlagEffect(tp,100212101)==0)
		or (re:IsActiveType(TYPE_TRAP) and Duel.GetFlagEffect(tp,100212201)==0))
end
function c12381100.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:IsActiveType(TYPE_MONSTER) then
		Duel.RegisterFlagEffect(tp,12381100,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(12381100,3))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		Duel.RegisterEffect(e1,tp)
	elseif re:IsActiveType(TYPE_SPELL) then
		Duel.RegisterFlagEffect(tp,100212101,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(12381100,4))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
	else re:IsActiveType(TYPE_TRAP)
		Duel.RegisterFlagEffect(tp,100212201,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(12381100,5))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
	end
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c12381100.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c12381100.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function c12381100.spfilter(c,e,tp)
	return (c:IsFusionSetCard(0xdd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		or c:IsFusionSetCard(0xcf) and c:IsFusionType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false))
		and (c:IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function c12381100.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12381100.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c12381100.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c12381100.spfilter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end